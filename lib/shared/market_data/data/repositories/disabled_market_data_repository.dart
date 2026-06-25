import 'package:stockubl/core/error/app_failure.dart';
import 'package:stockubl/core/error/result.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_quote.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_stream_status.dart';
import 'package:stockubl/shared/market_data/domain/entities/price_tick.dart';
import 'package:stockubl/shared/market_data/domain/repositories/market_data_repository.dart';

final class DisabledMarketDataRepository implements MarketDataRepository {
  const DisabledMarketDataRepository();

  @override
  Stream<PriceTick> get priceTicks => const Stream<PriceTick>.empty();

  @override
  Stream<MarketStreamStatus> get streamStatuses =>
      const Stream<MarketStreamStatus>.empty();

  @override
  Future<Result<MarketQuote>> fetchQuote(String symbol) async {
    return const FailureResult(
      ConfigurationFailure(
        message: 'Production market-data gateway is not configured.',
      ),
    );
  }

  @override
  Future<void> startStreaming(Set<String> symbols) async {}

  @override
  Future<void> updateSubscriptions(Set<String> symbols) async {}

  @override
  Future<void> pauseStreaming() async {}

  @override
  Future<void> resumeStreaming() async {}

  @override
  Future<void> dispose() async {}
}
