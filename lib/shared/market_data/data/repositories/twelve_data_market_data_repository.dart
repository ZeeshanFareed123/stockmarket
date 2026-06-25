import 'package:stockubl/core/error/result.dart';
import 'package:stockubl/core/network/network_failure_mapper.dart';
import 'package:stockubl/shared/market_data/data/data_sources/twelve_data_rest_data_source.dart';
import 'package:stockubl/shared/market_data/data/data_sources/twelve_data_web_socket_data_source.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_quote.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_stream_status.dart';
import 'package:stockubl/shared/market_data/domain/entities/price_tick.dart';
import 'package:stockubl/shared/market_data/domain/repositories/market_data_repository.dart';

final class TwelveDataMarketDataRepository implements MarketDataRepository {
  const TwelveDataMarketDataRepository({
    required TwelveDataRestDataSource restDataSource,
    required TwelveDataWebSocketDataSource webSocketDataSource,
  }) : _restDataSource = restDataSource,
       _webSocketDataSource = webSocketDataSource;

  final TwelveDataRestDataSource _restDataSource;
  final TwelveDataWebSocketDataSource _webSocketDataSource;

  @override
  Stream<PriceTick> get priceTicks => _webSocketDataSource.priceTicks;

  @override
  Stream<MarketStreamStatus> get streamStatuses =>
      _webSocketDataSource.statuses;

  @override
  Future<Result<MarketQuote>> fetchQuote(String symbol) async {
    try {
      final dto = await _restDataSource.fetchQuote(symbol);
      return Success(dto.toDomain());
    } on Object catch (error) {
      return FailureResult(NetworkFailureMapper.from(error));
    }
  }

  @override
  Future<void> startStreaming(Set<String> symbols) {
    return _webSocketDataSource.start(symbols);
  }

  @override
  Future<void> updateSubscriptions(Set<String> symbols) {
    return _webSocketDataSource.updateSubscriptions(symbols);
  }

  @override
  Future<void> pauseStreaming() {
    return _webSocketDataSource.pause();
  }

  @override
  Future<void> resumeStreaming() {
    return _webSocketDataSource.resume();
  }

  @override
  Future<void> dispose() {
    return _webSocketDataSource.dispose();
  }
}
