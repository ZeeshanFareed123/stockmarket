import 'package:decimal/decimal.dart';
import 'package:stockubl/shared/market_data/domain/entities/price_tick.dart';

final class TwelveDataPriceTickDto {
  const TwelveDataPriceTickDto({
    required this.symbol,
    required this.price,
    required this.timestamp,
    this.currency,
    this.exchange,
  });

  factory TwelveDataPriceTickDto.fromJson(Map<String, Object?> json) {
    final symbol = json['symbol']?.toString().trim();
    final price = Decimal.tryParse(json['price']?.toString() ?? '');
    final rawTimestamp = json['timestamp'];
    final timestamp = rawTimestamp is int
        ? rawTimestamp
        : int.tryParse(rawTimestamp?.toString() ?? '');

    if (symbol == null ||
        symbol.isEmpty ||
        price == null ||
        timestamp == null) {
      throw const FormatException('Invalid Twelve Data price event.');
    }

    return TwelveDataPriceTickDto(
      symbol: symbol,
      price: price,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        timestamp * 1000,
        isUtc: true,
      ),
      currency: json['currency']?.toString(),
      exchange: json['exchange']?.toString(),
    );
  }

  final String symbol;
  final Decimal price;
  final DateTime timestamp;
  final String? currency;
  final String? exchange;

  PriceTick toDomain() {
    return PriceTick(
      symbol: symbol,
      price: price,
      timestamp: timestamp,
      currency: currency,
      exchange: exchange,
    );
  }
}
