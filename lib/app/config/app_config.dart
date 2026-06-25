import 'package:stockubl/app/config/environment.dart';

final class AppConfig {
  const AppConfig({
    required this.appName,
    required this.environment,
    required this.apiBaseUrl,
    required this.marketDataWebSocketUrl,
    required this.marketDataApiKey,
    required this.initialMarketSymbols,
    required this.enableNetworkLogs,
    required this.maxStreamedSymbols,
  });

  factory AppConfig.forEnvironment(AppEnvironment environment) {
    const twelveDataApiKey = String.fromEnvironment(
      'TWELVE_DATA_API_KEY',
      defaultValue: 'demo',
    );

    return switch (environment) {
      AppEnvironment.mock => const AppConfig(
        appName: 'StockUBL',
        environment: AppEnvironment.mock,
        apiBaseUrl: '',
        marketDataWebSocketUrl: '',
        marketDataApiKey: '',
        initialMarketSymbols: ['BTC/USD', 'AAPL', 'TSLA', 'QQQ', 'GLD', 'USO'],
        enableNetworkLogs: true,
        maxStreamedSymbols: 8,
      ),
      AppEnvironment.twelveData => AppConfig(
        appName: 'StockUBL',
        environment: AppEnvironment.twelveData,
        apiBaseUrl: 'https://api.twelvedata.com',
        marketDataWebSocketUrl: 'wss://ws.twelvedata.com/v1/quotes/price',
        marketDataApiKey: twelveDataApiKey,
        initialMarketSymbols: const [
          'BTC/USD',
          'AAPL',
          'TSLA',
          'QQQ',
          'GLD',
          'USO',
        ],
        enableNetworkLogs: true,
        maxStreamedSymbols: 8,
      ),
      AppEnvironment.production => const AppConfig(
        appName: 'StockUBL',
        environment: AppEnvironment.production,
        apiBaseUrl: '',
        marketDataWebSocketUrl: '',
        marketDataApiKey: '',
        initialMarketSymbols: [],
        enableNetworkLogs: false,
        maxStreamedSymbols: 50,
      ),
    };
  }

  final String appName;
  final AppEnvironment environment;
  final String apiBaseUrl;
  final String marketDataWebSocketUrl;
  final String marketDataApiKey;
  final List<String> initialMarketSymbols;
  final bool enableNetworkLogs;
  final int maxStreamedSymbols;

  bool get isProduction => environment == AppEnvironment.production;
  bool get usesDemoMarketDataKey => marketDataApiKey == 'demo';
}
