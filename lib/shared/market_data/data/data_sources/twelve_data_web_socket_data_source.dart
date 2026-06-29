import 'dart:async';
import 'dart:convert';

import 'package:stockubl/core/logging/app_logger.dart';
import 'package:stockubl/shared/market_data/data/dtos/twelve_data_price_tick_dto.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_stream_status.dart';
import 'package:stockubl/shared/market_data/domain/entities/price_tick.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final class TwelveDataWebSocketDataSource {
  TwelveDataWebSocketDataSource({
    required String webSocketUrl,
    required String apiKey,
  }) : _webSocketUrl = webSocketUrl,
       _apiKey = apiKey;

  static const _scope = 'market.websocket';
  static const _reconnectDelays = [1, 2, 4, 8, 16, 30];
  static const _watchdogInterval = Duration(seconds: 15);
  static const _watchdogTimeout = Duration(seconds: 35);

  final String _webSocketUrl;
  final String _apiKey;
  final StreamController<PriceTick> _tickController =
      StreamController<PriceTick>.broadcast();
  final StreamController<MarketStreamStatus> _statusController =
      StreamController<MarketStreamStatus>.broadcast();

  WebSocketChannel? _channel;
  StreamSubscription<Object?>? _messageSubscription;
  Timer? _heartbeatTimer;
  Timer? _watchdogTimer;
  Timer? _reconnectTimer;
  DateTime? _lastMessageAt;
  Set<String> _desiredSymbols = {};
  Set<String> _subscribedSymbols = {};
  bool _shouldReconnect = false;
  bool _isConnecting = false;
  bool _isDisposed = false;
  int _reconnectAttempt = 0;
  MarketStreamConnection _lastConnection = MarketStreamConnection.disconnected;

  Stream<PriceTick> get priceTicks => _tickController.stream;
  Stream<MarketStreamStatus> get statuses => _statusController.stream;

  Future<void> start(Set<String> symbols) async {
    _desiredSymbols = _normalize(symbols);
    _shouldReconnect = true;
    await _connect();
  }

  Future<void> updateSubscriptions(Set<String> symbols) async {
    _desiredSymbols = _normalize(symbols);
    await _syncSubscriptions();

    if (_desiredSymbols.isEmpty) {
      await pause();
    } else if (_channel == null && _shouldReconnect) {
      await _connect();
    }
  }

  Future<void> pause() async {
    if (_lastConnection == MarketStreamConnection.paused) {
      return;
    }
    _shouldReconnect = false;
    _cancelReconnect();
    await _disconnect(
      status: const MarketStreamStatus(
        connection: MarketStreamConnection.paused,
      ),
    );
  }

  Future<void> resume() async {
    if (_desiredSymbols.isEmpty || _isDisposed) {
      return;
    }

    _shouldReconnect = true;
    await _connect();
  }

  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;
    _shouldReconnect = false;
    _cancelReconnect();
    await _disconnect(status: const MarketStreamStatus.disconnected());
    await _tickController.close();
    await _statusController.close();
  }

  Future<void> _connect() async {
    if (_isDisposed ||
        _isConnecting ||
        _channel != null ||
        _desiredSymbols.isEmpty) {
      return;
    }

    if (_apiKey.isEmpty || _webSocketUrl.isEmpty) {
      _emitStatus(
        const MarketStreamStatus(
          connection: MarketStreamConnection.failed,
          message: 'Twelve Data WebSocket configuration is missing.',
        ),
      );
      return;
    }

    if (_apiKey == 'demo') {
      _shouldReconnect = false;
      const message =
          'The Twelve Data demo key supports REST familiarity only. '
          'Provide your own API key to enable WebSocket streaming.';
      _emitStatus(
        const MarketStreamStatus(
          connection: MarketStreamConnection.failed,
          message: message,
        ),
      );
      AppLogger.warning(message, scope: _scope);
      return;
    }

    _isConnecting = true;
    final reconnecting = _reconnectAttempt > 0;
    _emitStatus(
      MarketStreamStatus(
        connection: reconnecting
            ? MarketStreamConnection.reconnecting
            : MarketStreamConnection.connecting,
        retryAttempt: _reconnectAttempt,
      ),
    );
    AppLogger.info(
      reconnecting ? 'Reconnecting stream' : 'Connecting stream',
      scope: _scope,
      data: {
        'attempt': _reconnectAttempt,
        'symbols': _desiredSymbols.toList(growable: false),
      },
    );

    WebSocketChannel? channel;
    try {
      final uri = Uri.parse(
        _webSocketUrl,
      ).replace(queryParameters: {'apikey': _apiKey});
      channel = WebSocketChannel.connect(uri);
      _channel = channel;
      _messageSubscription = channel.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );

      await channel.ready.timeout(const Duration(seconds: 15));
      _reconnectAttempt = 0;
      _isConnecting = false;
      _lastMessageAt = DateTime.now();
      _emitStatus(
        const MarketStreamStatus(connection: MarketStreamConnection.connected),
      );
      AppLogger.info('Stream connected', scope: _scope);
      await _syncSubscriptions();
      _startHeartbeat();
      _startWatchdog();
    } on Object catch (error, stackTrace) {
      _isConnecting = false;
      AppLogger.error(
        'Stream connection failed',
        scope: _scope,
        error: error,
        stackTrace: stackTrace,
      );
      if (identical(_channel, channel)) {
        _channel = null;
      }
      await _messageSubscription?.cancel();
      _messageSubscription = null;
      await channel?.sink.close();
      _scheduleReconnect(error.toString());
    }
  }

  Future<void> _syncSubscriptions() async {
    final channel = _channel;
    if (channel == null || _isConnecting) {
      return;
    }

    final additions = _desiredSymbols.difference(_subscribedSymbols);
    final removals = _subscribedSymbols.difference(_desiredSymbols);

    if (additions.isNotEmpty) {
      _sendSubscription('subscribe', additions);
    }
    if (removals.isNotEmpty) {
      _sendSubscription('unsubscribe', removals);
    }

    _subscribedSymbols = {..._desiredSymbols};
  }

  void _sendSubscription(String action, Set<String> symbols) {
    _channel?.sink.add(
      jsonEncode({
        'action': action,
        'params': {'symbols': symbols.join(',')},
      }),
    );
    AppLogger.info(
      'Stream $action requested',
      scope: _scope,
      data: {'symbols': symbols.toList(growable: false)},
    );
  }

  void _onMessage(Object? rawMessage) {
    _lastMessageAt = DateTime.now();
    try {
      final decoded = jsonDecode(rawMessage.toString());
      if (decoded is! Map) {
        return;
      }
      final event = decoded.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      final eventName = event['event']?.toString();

      if (eventName == 'price') {
        final tick = TwelveDataPriceTickDto.fromJson(event).toDomain();
        _tickController.add(tick);
        return;
      }

      final status = event['status']?.toString();
      if (status == 'error' || eventName == 'error') {
        final message = event['message']?.toString() ?? '';
        AppLogger.warning(
          'Provider stream error event',
          scope: _scope,
          data: _safeEvent(event),
        );
        if (_isApiLimitOrEntitlementMessage(message)) {
          _shouldReconnect = false;
          unawaited(
            _disconnect(
              status: MarketStreamStatus(
                connection: MarketStreamConnection.failed,
                message: _friendlyStreamMessage(message),
              ),
            ),
          );
        }
        return;
      }

      AppLogger.debug(
        'Stream control event',
        scope: _scope,
        data: _safeEvent(event),
      );
    } on Object catch (error, stackTrace) {
      AppLogger.warning(
        'Ignored malformed stream event',
        scope: _scope,
        error: error,
        data: {'runtimeType': rawMessage.runtimeType.toString()},
      );
      AppLogger.debug(
        'Malformed stream trace',
        scope: _scope,
        data: stackTrace.toString(),
      );
    }
  }

  void _onError(Object error, StackTrace stackTrace) {
    AppLogger.error(
      'Stream transport error',
      scope: _scope,
      error: error,
      stackTrace: stackTrace,
    );
    unawaited(_handleUnexpectedDisconnect(error.toString()));
  }

  void _onDone() {
    AppLogger.warning('Stream closed', scope: _scope);
    unawaited(_handleUnexpectedDisconnect('WebSocket closed.'));
  }

  Future<void> _handleUnexpectedDisconnect(String message) async {
    _stopRealtimeTimers();
    await _messageSubscription?.cancel();
    _messageSubscription = null;
    _channel = null;
    _isConnecting = false;
    _subscribedSymbols = {};

    if (_shouldReconnect && !_isDisposed) {
      _scheduleReconnect(message);
    } else {
      _emitStatus(const MarketStreamStatus.disconnected());
    }
  }

  void _scheduleReconnect(String message) {
    if (!_shouldReconnect || _isDisposed || _reconnectTimer != null) {
      return;
    }

    if (_reconnectAttempt >= _reconnectDelays.length) {
      _shouldReconnect = false;
      const failureMessage =
          'WebSocket reconnect limit reached. Check the API key, plan '
          'entitlement, and network before retrying.';
      _emitStatus(
        const MarketStreamStatus(
          connection: MarketStreamConnection.failed,
          message: failureMessage,
        ),
      );
      AppLogger.error(
        failureMessage,
        scope: _scope,
        data: {'lastError': message},
      );
      return;
    }

    final index = _reconnectAttempt
        .clamp(0, _reconnectDelays.length - 1)
        .toInt();
    final delay = Duration(seconds: _reconnectDelays[index]);
    _reconnectAttempt++;
    _emitStatus(
      MarketStreamStatus(
        connection: MarketStreamConnection.reconnecting,
        message: message,
        retryAttempt: _reconnectAttempt,
      ),
    );
    AppLogger.warning(
      'Stream reconnect scheduled',
      scope: _scope,
      data: {'delaySeconds': delay.inSeconds, 'attempt': _reconnectAttempt},
    );

    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      unawaited(_connect());
    });
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      try {
        _channel?.sink.add(jsonEncode({'action': 'heartbeat'}));
      } on Object catch (error) {
        AppLogger.warning('Heartbeat failed', scope: _scope, error: error);
      }
    });
  }

  void _startWatchdog() {
    _watchdogTimer?.cancel();
    _watchdogTimer = Timer.periodic(_watchdogInterval, (_) {
      final lastMessageAt = _lastMessageAt;
      if (lastMessageAt == null || _channel == null || _isConnecting) {
        return;
      }

      final silence = DateTime.now().difference(lastMessageAt);
      if (silence < _watchdogTimeout) {
        return;
      }

      AppLogger.warning(
        'Stream watchdog triggered reconnect',
        scope: _scope,
        data: {'silenceSeconds': silence.inSeconds},
      );
      unawaited(
        _handleUnexpectedDisconnect(
          'No market stream updates received. Reconnecting...',
        ),
      );
    });
  }

  Future<void> _disconnect({required MarketStreamStatus status}) async {
    _stopRealtimeTimers();
    await _messageSubscription?.cancel();
    _messageSubscription = null;
    final channel = _channel;
    _channel = null;
    _isConnecting = false;
    _subscribedSymbols = {};
    await channel?.sink.close();
    _emitStatus(status);
  }

  void _stopRealtimeTimers() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _watchdogTimer?.cancel();
    _watchdogTimer = null;
    _lastMessageAt = null;
  }

  void _cancelReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _reconnectAttempt = 0;
  }

  void _emitStatus(MarketStreamStatus status) {
    _lastConnection = status.connection;
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }

  Set<String> _normalize(Set<String> symbols) {
    return symbols
        .map((symbol) => symbol.trim().toUpperCase())
        .where((symbol) => symbol.isNotEmpty)
        .toSet();
  }

  Map<String, Object?> _safeEvent(Map<String, Object?> event) {
    return {
      if (event['event'] != null) 'event': event['event'],
      if (event['status'] != null) 'status': event['status'],
      if (event['message'] != null) 'message': event['message'],
      if (event['success'] != null) 'success': event['success'],
      if (event['fails'] != null) 'fails': event['fails'],
    };
  }

  bool _isApiLimitOrEntitlementMessage(String message) {
    final lowerMessage = message.toLowerCase();
    return lowerMessage.contains('limit') ||
        lowerMessage.contains('credits') ||
        lowerMessage.contains('apikey') ||
        lowerMessage.contains('api key') ||
        lowerMessage.contains('entitlement') ||
        lowerMessage.contains('plan');
  }

  String _friendlyStreamMessage(String message) {
    final lowerMessage = message.toLowerCase();
    if (lowerMessage.contains('limit') || lowerMessage.contains('credits')) {
      return 'Market data stream limit reached. Please wait before retrying.';
    }
    if (lowerMessage.contains('apikey') || lowerMessage.contains('api key')) {
      return 'Market data API key is missing, expired, or not allowed.';
    }
    if (lowerMessage.contains('plan') || lowerMessage.contains('entitlement')) {
      return 'This API plan does not allow the requested live stream.';
    }
    return message.isEmpty ? 'Market data stream failed.' : message;
  }
}
