import 'package:stockubl/core/network/api_client.dart';
import 'package:stockubl/shared/market_data/data/dtos/twelve_data_quote_dto.dart';

final class TwelveDataRestDataSource {
  const TwelveDataRestDataSource({
    required ApiClient apiClient,
    required String apiKey,
  }) : _apiClient = apiClient,
       _apiKey = apiKey;

  final ApiClient _apiClient;
  final String _apiKey;

  Future<TwelveDataQuoteDto> fetchQuote(String symbol) {
    return _apiClient.get(
      '/quote',
      queryParameters: {'symbol': symbol, 'apikey': _apiKey},
      decode: TwelveDataQuoteDto.fromJson,
    );
  }
}
