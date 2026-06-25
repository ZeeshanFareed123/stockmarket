import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockubl/features/markets/domain/market_instrument_catalog.dart';
import 'package:stockubl/features/markets/presentation/models/market_instrument_view_data.dart';
import 'package:stockubl/shared/market_data/application/market_data_state.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_quote.dart';
import 'package:stockubl/shared/market_data/domain/entities/price_tick.dart';

void main() {
  test('uses live tick and recalculates change against previous close', () {
    final state = MarketDataState(
      snapshots: {
        'AAPL': MarketQuote(
          symbol: 'AAPL',
          name: 'Apple Inc.',
          exchange: 'NASDAQ',
          currency: 'USD',
          price: Decimal.parse('100'),
          previousClose: Decimal.parse('80'),
          change: Decimal.parse('20'),
          percentChange: Decimal.parse('25'),
          timestamp: DateTime.utc(2026, 6, 26),
          isMarketOpen: true,
        ),
      },
      latestTicks: {
        'AAPL': PriceTick(
          symbol: 'AAPL',
          price: Decimal.parse('88'),
          timestamp: DateTime.utc(2026, 6, 26, 1),
        ),
      },
      priceSeries: {
        'AAPL': [Decimal.parse('80'), Decimal.parse('88')],
      },
    );

    final viewData = MarketInstrumentViewData.fromState(
      definition: MarketInstrumentCatalog.popular.firstWhere(
        (instrument) => instrument.symbol == 'AAPL',
      ),
      state: state,
    );

    expect(viewData.price.toString(), '88');
    expect(viewData.percentChange.toString(), '10');
    expect(viewData.isLive, isTrue);
    expect(viewData.priceSeries, hasLength(2));
  });
}
