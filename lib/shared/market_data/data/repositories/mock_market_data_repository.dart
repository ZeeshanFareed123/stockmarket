import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:stockubl/core/error/result.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_quote.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_stream_status.dart';
import 'package:stockubl/shared/market_data/domain/entities/price_tick.dart';
import 'package:stockubl/shared/market_data/domain/repositories/market_data_repository.dart';

final class MockMarketDataRepository implements MarketDataRepository {
  final StreamController<PriceTick> _tickController =
      StreamController<PriceTick>.broadcast();
  final StreamController<MarketStreamStatus> _statusController =
      StreamController<MarketStreamStatus>.broadcast();

  Timer? _timer;
  Set<String> _symbols = {};
  int _tick = 0;
  final Map<String, Decimal> _lastPrices = {};

  @override
  Stream<PriceTick> get priceTicks => _tickController.stream;

  @override
  Stream<MarketStreamStatus> get streamStatuses => _statusController.stream;

  @override
  Future<Result<MarketQuote>> fetchQuote(String symbol) async {
    return Success(
      MarketQuote(
        symbol: symbol,
        name: symbol == 'AAPL' ? 'Apple Inc.' : symbol,
        exchange: 'NASDAQ',
        currency: 'USD',
        price: Decimal.parse('275.05'),
        previousClose: Decimal.parse('273.80'),
        change: Decimal.parse('1.25'),
        percentChange: Decimal.parse('0.46'),
        timestamp: DateTime.now().toUtc(),
        isMarketOpen: true,
      ),
    );
  }

  @override
  Future<void> startStreaming(Set<String> symbols) async {
    _symbols = {...symbols};
    _statusController.add(
      const MarketStreamStatus(connection: MarketStreamConnection.connected),
    );
    _startTimer();
  }

  @override
  Future<void> updateSubscriptions(Set<String> symbols) async {
    _symbols = {...symbols};
    _startTimer();
  }

  @override
  Future<void> pauseStreaming() async {
    _timer?.cancel();
    _timer = null;
    _statusController.add(
      const MarketStreamStatus(connection: MarketStreamConnection.paused),
    );
  }

  @override
  Future<void> resumeStreaming() async {
    _statusController.add(
      const MarketStreamStatus(connection: MarketStreamConnection.connected),
    );
    _startTimer();
  }

  @override
  Future<void> dispose() async {
    _timer?.cancel();
    await _tickController.close();
    await _statusController.close();
  }

  void _startTimer() {
    _timer?.cancel();
    if (_symbols.isEmpty) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _tick++;
      for (final symbol in _symbols) {
        final base = _lastPrices[symbol] ?? Decimal.parse('275.05');
        final direction = ((_tick + symbol.length) % 6) < 4 ? 1 : -1;
        final step = 0.03 + (((_tick + symbol.codeUnitAt(0)) % 4) * 0.02);
        final price = Decimal.parse(
          (double.parse(base.toString()) + (direction * step)).toStringAsFixed(
            2,
          ),
        );
        _lastPrices[symbol] = price;
        _tickController.add(
          PriceTick(
            symbol: symbol,
            price: price,
            timestamp: DateTime.now().toUtc(),
            currency: 'USD',
            exchange: 'NASDAQ',
          ),
        );
      }
    });
  }
}
