import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockubl/app/config/app_config.dart';
import 'package:stockubl/app/config/app_config_provider.dart';
import 'package:stockubl/app/config/environment.dart';
import 'package:stockubl/core/error/result.dart';
import 'package:stockubl/shared/market_data/application/market_data_controller.dart';
import 'package:stockubl/shared/market_data/data/market_data_repository_provider.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_quote.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_stream_status.dart';
import 'package:stockubl/shared/market_data/domain/entities/price_tick.dart';
import 'package:stockubl/shared/market_data/domain/repositories/market_data_repository.dart';

void main() {
  test('loads a REST snapshot then applies live ticks', () async {
    final repository = _FakeMarketDataRepository();
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(
            appName: 'Test',
            environment: AppEnvironment.mock,
            apiBaseUrl: '',
            marketDataWebSocketUrl: '',
            marketDataApiKey: '',
            initialMarketSymbols: ['AAPL'],
            enableNetworkLogs: false,
            maxStreamedSymbols: 8,
          ),
        ),
        marketDataRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    await container.read(marketDataControllerProvider.notifier).start(const [
      'AAPL',
    ]);

    expect(
      container
          .read(marketDataControllerProvider)
          .snapshots['AAPL']
          ?.price
          .toString(),
      '275.05',
    );

    repository.emitTick(
      PriceTick(
        symbol: 'AAPL',
        price: Decimal.parse('276.10'),
        timestamp: DateTime.utc(2026, 6, 26),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(
      container
          .read(marketDataControllerProvider)
          .latestTicks['AAPL']
          ?.price
          .toString(),
      '276.1',
    );
  });
}

final class _FakeMarketDataRepository implements MarketDataRepository {
  final _ticks = StreamController<PriceTick>.broadcast();
  final _statuses = StreamController<MarketStreamStatus>.broadcast();

  void emitTick(PriceTick tick) => _ticks.add(tick);

  @override
  Stream<PriceTick> get priceTicks => _ticks.stream;

  @override
  Stream<MarketStreamStatus> get streamStatuses => _statuses.stream;

  @override
  Future<Result<MarketQuote>> fetchQuote(String symbol) async {
    return Success(
      MarketQuote(
        symbol: symbol,
        name: 'Apple Inc.',
        exchange: 'NASDAQ',
        currency: 'USD',
        price: Decimal.parse('275.05'),
        previousClose: Decimal.parse('273.80'),
        change: Decimal.parse('1.25'),
        percentChange: Decimal.parse('0.46'),
        timestamp: DateTime.utc(2026, 6, 26),
        isMarketOpen: true,
      ),
    );
  }

  @override
  Future<void> startStreaming(Set<String> symbols) async {
    _statuses.add(
      const MarketStreamStatus(connection: MarketStreamConnection.connected),
    );
  }

  @override
  Future<void> updateSubscriptions(Set<String> symbols) async {}

  @override
  Future<void> pauseStreaming() async {}

  @override
  Future<void> resumeStreaming() async {}

  @override
  Future<void> dispose() async {
    await _ticks.close();
    await _statuses.close();
  }
}
