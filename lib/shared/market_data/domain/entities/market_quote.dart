import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';

@immutable
final class MarketQuote {
  const MarketQuote({
    required this.symbol,
    required this.name,
    required this.exchange,
    required this.currency,
    required this.price,
    required this.previousClose,
    required this.change,
    required this.percentChange,
    required this.timestamp,
    required this.isMarketOpen,
  });

  final String symbol;
  final String name;
  final String exchange;
  final String currency;
  final Decimal price;
  final Decimal previousClose;
  final Decimal change;
  final Decimal percentChange;
  final DateTime timestamp;
  final bool isMarketOpen;

  Map<String, Object?> toLogData() {
    return {
      'symbol': symbol,
      'price': price.toString(),
      'change': change.toString(),
      'percentChange': percentChange.toString(),
      'currency': currency,
      'marketOpen': isMarketOpen,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
