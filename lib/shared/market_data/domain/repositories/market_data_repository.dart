import 'package:stockubl/core/error/result.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_quote.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_stream_status.dart';
import 'package:stockubl/shared/market_data/domain/entities/price_tick.dart';

abstract interface class MarketDataRepository {
  Stream<PriceTick> get priceTicks;
  Stream<MarketStreamStatus> get streamStatuses;

  Future<Result<MarketQuote>> fetchQuote(String symbol);
  Future<void> startStreaming(Set<String> symbols);
  Future<void> updateSubscriptions(Set<String> symbols);
  Future<void> pauseStreaming();
  Future<void> resumeStreaming();
  Future<void> dispose();
}
