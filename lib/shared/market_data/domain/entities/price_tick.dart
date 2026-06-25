import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';

@immutable
final class PriceTick {
  const PriceTick({
    required this.symbol,
    required this.price,
    required this.timestamp,
    this.currency,
    this.exchange,
  });

  final String symbol;
  final Decimal price;
  final DateTime timestamp;
  final String? currency;
  final String? exchange;

  Map<String, Object?> toLogData() {
    return {
      'symbol': symbol,
      'price': price.toString(),
      'currency': currency,
      'exchange': exchange,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
