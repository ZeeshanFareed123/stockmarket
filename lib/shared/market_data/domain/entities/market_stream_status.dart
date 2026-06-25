import 'package:flutter/foundation.dart';

enum MarketStreamConnection {
  disconnected,
  connecting,
  connected,
  reconnecting,
  paused,
  failed,
}

@immutable
final class MarketStreamStatus {
  const MarketStreamStatus({
    required this.connection,
    this.message,
    this.retryAttempt = 0,
  });

  const MarketStreamStatus.disconnected()
    : this(connection: MarketStreamConnection.disconnected);

  final MarketStreamConnection connection;
  final String? message;
  final int retryAttempt;
}
