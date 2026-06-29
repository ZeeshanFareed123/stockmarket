import 'package:decimal/decimal.dart';
import 'package:stockubl/core/error/app_failure.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_quote.dart';

final class TwelveDataQuoteDto {
  const TwelveDataQuoteDto({
    required this.symbol,
    required this.name,
    required this.exchange,
    required this.currency,
    required this.close,
    required this.previousClose,
    required this.change,
    required this.percentChange,
    required this.timestamp,
    required this.isMarketOpen,
  });

  factory TwelveDataQuoteDto.fromJson(Object? data) {
    final json = _jsonMap(data);
    _throwIfProviderError(json);

    return TwelveDataQuoteDto(
      symbol: _requiredString(json, 'symbol'),
      name: _optionalString(json, 'name'),
      exchange: _optionalString(json, 'exchange'),
      currency: _optionalString(json, 'currency'),
      close: _requiredDecimal(json, 'close'),
      previousClose: _requiredDecimal(json, 'previous_close'),
      change: _requiredDecimal(json, 'change'),
      percentChange: _requiredDecimal(json, 'percent_change'),
      timestamp: _requiredTimestamp(json, 'timestamp'),
      isMarketOpen: json['is_market_open'] == true,
    );
  }

  final String symbol;
  final String name;
  final String exchange;
  final String currency;
  final Decimal close;
  final Decimal previousClose;
  final Decimal change;
  final Decimal percentChange;
  final DateTime timestamp;
  final bool isMarketOpen;

  MarketQuote toDomain() {
    return MarketQuote(
      symbol: symbol,
      name: name,
      exchange: exchange,
      currency: currency,
      price: close,
      previousClose: previousClose,
      change: change,
      percentChange: percentChange,
      timestamp: timestamp,
      isMarketOpen: isMarketOpen,
    );
  }
}

Map<String, Object?> _jsonMap(Object? data) {
  if (data is! Map) {
    throw const FormatException('Expected a JSON object.');
  }

  return data.map((key, value) => MapEntry(key.toString(), value));
}

void _throwIfProviderError(Map<String, Object?> json) {
  if (json['status'] != 'error') {
    return;
  }

  throw ProviderFailure(
    message: _friendlyProviderMessage(json),
  );
}

String _friendlyProviderMessage(Map<String, Object?> json) {
  final rawMessage = _optionalString(
    json,
    'message',
    fallback: 'Provider error.',
  );
  final code = json['code']?.toString().trim().toLowerCase() ?? '';
  final message = rawMessage.toLowerCase();

  if (code == '429' ||
      message.contains('limit') ||
      message.contains('credits') ||
      message.contains('rate')) {
    return 'Market data limit reached. Please wait a minute before retrying.';
  }

  if (message.contains('apikey') ||
      message.contains('api key') ||
      message.contains('unauthorized')) {
    return 'Market data API key is missing, expired, or not allowed.';
  }

  if (message.contains('symbol')) {
    return 'This market symbol is not available from the data provider.';
  }

  return rawMessage;
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key]?.toString().trim();
  if (value == null || value.isEmpty) {
    throw FormatException('Missing $key.');
  }
  return value;
}

String _optionalString(
  Map<String, Object?> json,
  String key, {
  String fallback = '',
}) {
  final value = json[key]?.toString().trim();
  return value == null || value.isEmpty ? fallback : value;
}

Decimal _requiredDecimal(Map<String, Object?> json, String key) {
  final value = json[key]?.toString();
  if (value == null) {
    throw FormatException('Missing $key.');
  }

  return Decimal.tryParse(value) ??
      (throw FormatException('Invalid decimal $key.'));
}

DateTime _requiredTimestamp(Map<String, Object?> json, String key) {
  final value = json[key];
  final seconds = value is int ? value : int.tryParse(value?.toString() ?? '');
  if (seconds == null) {
    throw FormatException('Invalid timestamp $key.');
  }

  return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
}
