import 'package:flutter_test/flutter_test.dart';
import 'package:stockubl/shared/market_data/data/data_sources/twelve_data_web_socket_data_source.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_stream_status.dart';

void main() {
  test('demo key reports a permanent REST-only stream status', () async {
    final dataSource = TwelveDataWebSocketDataSource(
      webSocketUrl: 'wss://ws.twelvedata.com/v1/quotes/price',
      apiKey: 'demo',
    );
    addTearDown(dataSource.dispose);

    final statusFuture = dataSource.statuses.first;
    await dataSource.start({'AAPL'});
    final status = await statusFuture;

    expect(status.connection, MarketStreamConnection.failed);
    expect(status.message, contains('demo key supports REST'));
  });
}
