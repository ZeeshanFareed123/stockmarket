import 'package:decimal/decimal.dart';
import 'package:stockubl/features/markets/domain/market_instrument_catalog.dart';
import 'package:stockubl/shared/market_data/application/market_data_state.dart';

final class MarketInstrumentViewData {
  const MarketInstrumentViewData({
    required this.definition,
    required this.price,
    required this.percentChange,
    required this.updatedAt,
    required this.priceSeries,
    required this.isLive,
    required this.isLoading,
  });

  factory MarketInstrumentViewData.fromState({
    required MarketInstrumentDefinition definition,
    required MarketDataState state,
  }) {
    final quote = state.snapshots[definition.symbol];
    final tick = state.latestTicks[definition.symbol];
    final price = tick?.price ?? quote?.price;
    final previousClose = quote?.previousClose;
    Decimal? percentChange = quote?.percentChange;

    if (tick != null &&
        previousClose != null &&
        previousClose != Decimal.zero) {
      final livePrice = double.parse(tick.price.toString());
      final referencePrice = double.parse(previousClose.toString());
      percentChange = Decimal.parse(
        (((livePrice - referencePrice) / referencePrice) * 100).toStringAsFixed(
          4,
        ),
      );
    }

    return MarketInstrumentViewData(
      definition: definition,
      price: price,
      percentChange: percentChange,
      updatedAt: tick?.timestamp ?? quote?.timestamp,
      priceSeries: state.priceSeries[definition.symbol] ?? const [],
      isLive: tick != null,
      isLoading: state.isLoadingSnapshots && quote == null,
    );
  }

  final MarketInstrumentDefinition definition;
  final Decimal? price;
  final Decimal? percentChange;
  final DateTime? updatedAt;
  final List<Decimal> priceSeries;
  final bool isLive;
  final bool isLoading;

  bool get isPositive => percentChange != null && percentChange! > Decimal.zero;

  bool get isNegative => percentChange != null && percentChange! < Decimal.zero;
}
