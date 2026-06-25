import 'package:stockubl/app/config/environment.dart';

final class AppConfig {
  const AppConfig({
    required this.appName,
    required this.environment,
    required this.apiBaseUrl,
    required this.enableNetworkLogs,
    required this.maxStreamedSymbols,
  });

  factory AppConfig.forEnvironment(AppEnvironment environment) {
    return switch (environment) {
      AppEnvironment.mock => const AppConfig(
        appName: 'StockUBL',
        environment: AppEnvironment.mock,
        apiBaseUrl: '',
        enableNetworkLogs: true,
        maxStreamedSymbols: 8,
      ),
      AppEnvironment.twelveData => const AppConfig(
        appName: 'StockUBL',
        environment: AppEnvironment.twelveData,
        apiBaseUrl: 'https://api.twelvedata.com',
        enableNetworkLogs: true,
        maxStreamedSymbols: 8,
      ),
      AppEnvironment.production => const AppConfig(
        appName: 'StockUBL',
        environment: AppEnvironment.production,
        apiBaseUrl: '',
        enableNetworkLogs: false,
        maxStreamedSymbols: 50,
      ),
    };
  }

  final String appName;
  final AppEnvironment environment;
  final String apiBaseUrl;
  final bool enableNetworkLogs;
  final int maxStreamedSymbols;

  bool get isProduction => environment == AppEnvironment.production;
}
