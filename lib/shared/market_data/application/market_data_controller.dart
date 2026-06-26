import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stockubl/app/config/app_config_provider.dart';
import 'package:stockubl/core/logging/app_logger.dart';
import 'package:stockubl/shared/market_data/application/market_data_state.dart';
import 'package:stockubl/shared/market_data/data/market_data_repository_provider.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_stream_status.dart';
import 'package:stockubl/shared/market_data/domain/entities/price_tick.dart';

part 'market_data_controller.g.dart';

@Riverpod(keepAlive: true)
class MarketDataController extends _$MarketDataController {
  static const _scope = 'market.engine';
  static const _minimumTickDisplayInterval = Duration(seconds: 4);

  StreamSubscription<PriceTick>? _tickSubscription;
  StreamSubscription<MarketStreamStatus>? _statusSubscription;
  final Map<String, DateTime> _lastAppliedTickAt = {};
  final Map<String, PriceTick> _pendingTicks = {};
  final Map<String, Timer> _pendingTickTimers = {};
  bool _started = false;

  @override
  MarketDataState build() {
    final repository = ref.watch(marketDataRepositoryProvider);
    _tickSubscription = repository.priceTicks.listen(_onTick);
    _statusSubscription = repository.streamStatuses.listen(_onStatus);

    ref.onDispose(() {
      for (final timer in _pendingTickTimers.values) {
        timer.cancel();
      }
      unawaited(_tickSubscription?.cancel());
      unawaited(_statusSubscription?.cancel());
      unawaited(repository.dispose());
    });

    return const MarketDataState();
  }

  Future<void> start(Iterable<String> requestedSymbols) async {
    final symbols = _normalizeAndLimit(requestedSymbols);
    if (symbols.isEmpty) {
      AppLogger.warning('Market data start skipped: no symbols', scope: _scope);
      return;
    }

    if (_started && setEquals(state.symbols, symbols)) {
      return;
    }

    _started = true;
    _clearTickThrottle();
    state = state.copyWith(
      symbols: symbols,
      snapshots: const {},
      latestTicks: const {},
      priceSeries: const {},
      isLoadingSnapshots: true,
      clearFailure: true,
    );
    AppLogger.info(
      'Market data engine starting',
      scope: _scope,
      data: {
        'environment': ref.read(appConfigProvider).environment.name,
        'symbols': symbols.toList(growable: false),
      },
    );

    final repository = ref.read(marketDataRepositoryProvider);
    for (final symbol in symbols) {
      final result = await repository.fetchQuote(symbol);
      result.fold(
        onSuccess: (quote) {
          state = state.copyWith(
            snapshots: {...state.snapshots, symbol: quote},
            priceSeries: {
              ...state.priceSeries,
              symbol: [quote.previousClose, quote.price],
            },
            clearFailure: true,
          );
          AppLogger.info(
            'REST quote received',
            scope: _scope,
            data: quote.toLogData(),
          );
        },
        onFailure: (failure) {
          state = state.copyWith(lastFailure: failure);
          AppLogger.error(
            'REST quote failed',
            scope: _scope,
            data: {
              'symbol': symbol,
              'code': failure.code,
              'message': failure.message,
            },
            error: failure.cause,
          );
        },
      );
    }

    state = state.copyWith(isLoadingSnapshots: false);
    await repository.startStreaming(symbols);
  }

  Future<void> setSymbols(Iterable<String> requestedSymbols) async {
    final symbols = _normalizeAndLimit(requestedSymbols);
    state = state.copyWith(symbols: symbols);
    await ref.read(marketDataRepositoryProvider).updateSubscriptions(symbols);
  }

  Future<void> pause() {
    AppLogger.info('Market stream paused by lifecycle', scope: _scope);
    return ref.read(marketDataRepositoryProvider).pauseStreaming();
  }

  Future<void> resume() async {
    if (!_started) {
      return;
    }
    AppLogger.info('Market stream resumed by lifecycle', scope: _scope);
    await ref.read(marketDataRepositoryProvider).resumeStreaming();
  }

  void _onTick(PriceTick tick) {
    final now = DateTime.now();
    final lastApplied = _lastAppliedTickAt[tick.symbol];

    if (lastApplied == null ||
        now.difference(lastApplied) >= _minimumTickDisplayInterval) {
      _pendingTicks.remove(tick.symbol);
      _pendingTickTimers.remove(tick.symbol)?.cancel();
      _applyTick(tick, now);
      return;
    }

    _pendingTicks[tick.symbol] = tick;
    if (_pendingTickTimers.containsKey(tick.symbol)) {
      return;
    }

    final delay = _minimumTickDisplayInterval - now.difference(lastApplied);
    _pendingTickTimers[tick.symbol] = Timer(delay, () {
      _pendingTickTimers.remove(tick.symbol);
      final pendingTick = _pendingTicks.remove(tick.symbol);
      if (pendingTick != null) {
        _applyTick(pendingTick, DateTime.now());
      }
    });
  }

  void _applyTick(PriceTick tick, DateTime appliedAt) {
    final existing = state.priceSeries[tick.symbol] ?? const [];
    final updatedSeries = [...existing, tick.price];
    if (updatedSeries.length > 24) {
      updatedSeries.removeRange(0, updatedSeries.length - 24);
    }

    state = state.copyWith(
      latestTicks: {...state.latestTicks, tick.symbol: tick},
      priceSeries: {...state.priceSeries, tick.symbol: updatedSeries},
    );
    _lastAppliedTickAt[tick.symbol] = appliedAt;
    AppLogger.info('LIVE price tick', scope: _scope, data: tick.toLogData());
  }

  void _clearTickThrottle() {
    for (final timer in _pendingTickTimers.values) {
      timer.cancel();
    }
    _lastAppliedTickAt.clear();
    _pendingTicks.clear();
    _pendingTickTimers.clear();
  }

  void _onStatus(MarketStreamStatus status) {
    state = state.copyWith(streamStatus: status);
    AppLogger.info(
      'Stream status changed',
      scope: _scope,
      data: {
        'connection': status.connection.name,
        'retryAttempt': status.retryAttempt,
        if (status.message != null) 'message': status.message,
      },
    );
  }

  Set<String> _normalizeAndLimit(Iterable<String> requestedSymbols) {
    final limit = ref.read(appConfigProvider).maxStreamedSymbols;
    return requestedSymbols
        .map((symbol) => symbol.trim().toUpperCase())
        .where((symbol) => symbol.isNotEmpty)
        .take(limit)
        .toSet();
  }
}
