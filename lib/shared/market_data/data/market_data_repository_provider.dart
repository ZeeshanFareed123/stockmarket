import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stockubl/app/config/app_config_provider.dart';
import 'package:stockubl/app/config/environment.dart';
import 'package:stockubl/core/network/network_providers.dart';
import 'package:stockubl/shared/market_data/data/data_sources/twelve_data_rest_data_source.dart';
import 'package:stockubl/shared/market_data/data/data_sources/twelve_data_web_socket_data_source.dart';
import 'package:stockubl/shared/market_data/data/repositories/disabled_market_data_repository.dart';
import 'package:stockubl/shared/market_data/data/repositories/mock_market_data_repository.dart';
import 'package:stockubl/shared/market_data/data/repositories/twelve_data_market_data_repository.dart';
import 'package:stockubl/shared/market_data/domain/repositories/market_data_repository.dart';

part 'market_data_repository_provider.g.dart';

@Riverpod(keepAlive: true)
MarketDataRepository marketDataRepository(Ref ref) {
  final config = ref.watch(appConfigProvider);

  return switch (config.environment) {
    AppEnvironment.mock => MockMarketDataRepository(),
    AppEnvironment.twelveData => TwelveDataMarketDataRepository(
      restDataSource: TwelveDataRestDataSource(
        apiClient: ref.watch(apiClientProvider),
        apiKey: config.marketDataApiKey,
      ),
      webSocketDataSource: TwelveDataWebSocketDataSource(
        webSocketUrl: config.marketDataWebSocketUrl,
        apiKey: config.marketDataApiKey,
      ),
    ),
    AppEnvironment.production => const DisabledMarketDataRepository(),
  };
}
