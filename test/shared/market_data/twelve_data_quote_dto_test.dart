import 'package:flutter_test/flutter_test.dart';
import 'package:stockubl/core/error/app_failure.dart';
import 'package:stockubl/shared/market_data/data/dtos/twelve_data_quote_dto.dart';

void main() {
  test('maps a Twelve Data quote response to the domain model', () {
    final quote = TwelveDataQuoteDto.fromJson({
      'symbol': 'AAPL',
      'name': 'Apple Inc.',
      'exchange': 'NASDAQ',
      'currency': 'USD',
      'timestamp': 1782394200,
      'close': '275.049988',
      'previous_close': '293.079987',
      'change': '-18.029999',
      'percent_change': '-6.15190',
      'is_market_open': false,
    }).toDomain();

    expect(quote.symbol, 'AAPL');
    expect(quote.price.toString(), '275.049988');
    expect(quote.percentChange.toString(), '-6.1519');
    expect(quote.isMarketOpen, isFalse);
    expect(quote.timestamp.isUtc, isTrue);
  });

  test('surfaces provider errors without attempting DTO mapping', () {
    expect(
      () => TwelveDataQuoteDto.fromJson({
        'status': 'error',
        'code': 401,
        'message': 'Invalid API key.',
      }),
      throwsA(isA<ProviderFailure>()),
    );
  });
}
