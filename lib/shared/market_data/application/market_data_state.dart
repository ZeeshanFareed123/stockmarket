import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:stockubl/core/error/app_failure.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_quote.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_stream_status.dart';
import 'package:stockubl/shared/market_data/domain/entities/price_tick.dart';

@immutable
final class MarketDataState {
  const MarketDataState({
    this.symbols = const {},
    this.snapshots = const {},
    this.latestTicks = const {},
    this.priceSeries = const {},
    this.streamStatus = const MarketStreamStatus.disconnected(),
    this.isLoadingSnapshots = false,
    this.lastFailure,
  });

  final Set<String> symbols;
  final Map<String, MarketQuote> snapshots;
  final Map<String, PriceTick> latestTicks;
  final Map<String, List<Decimal>> priceSeries;
  final MarketStreamStatus streamStatus;
  final bool isLoadingSnapshots;
  final AppFailure? lastFailure;

  MarketDataState copyWith({
    Set<String>? symbols,
    Map<String, MarketQuote>? snapshots,
    Map<String, PriceTick>? latestTicks,
    Map<String, List<Decimal>>? priceSeries,
    MarketStreamStatus? streamStatus,
    bool? isLoadingSnapshots,
    AppFailure? lastFailure,
    bool clearFailure = false,
  }) {
    return MarketDataState(
      symbols: symbols ?? this.symbols,
      snapshots: snapshots ?? this.snapshots,
      latestTicks: latestTicks ?? this.latestTicks,
      priceSeries: priceSeries ?? this.priceSeries,
      streamStatus: streamStatus ?? this.streamStatus,
      isLoadingSnapshots: isLoadingSnapshots ?? this.isLoadingSnapshots,
      lastFailure: clearFailure ? null : lastFailure ?? this.lastFailure,
    );
  }
}
