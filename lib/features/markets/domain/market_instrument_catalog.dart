enum MarketCategory {
  popular('Popular'),
  stocks('Stocks'),
  crypto('Crypto'),
  etfs('ETFs');

  const MarketCategory(this.label);

  final String label;
}

final class MarketInstrumentDefinition {
  const MarketInstrumentDefinition({
    required this.symbol,
    required this.displayName,
    required this.badge,
    required this.category,
  });

  final String symbol;
  final String displayName;
  final String badge;
  final MarketCategory category;
}

abstract final class MarketInstrumentCatalog {
  static const popular = [
    MarketInstrumentDefinition(
      symbol: 'BTC/USD',
      displayName: 'Bitcoin',
      badge: '₿',
      category: MarketCategory.crypto,
    ),
    MarketInstrumentDefinition(
      symbol: 'AAPL',
      displayName: 'Apple',
      badge: 'A',
      category: MarketCategory.stocks,
    ),
    MarketInstrumentDefinition(
      symbol: 'TSLA',
      displayName: 'Tesla',
      badge: 'T',
      category: MarketCategory.stocks,
    ),
    MarketInstrumentDefinition(
      symbol: 'QQQ',
      displayName: 'Nasdaq 100 ETF',
      badge: 'Q',
      category: MarketCategory.etfs,
    ),
    MarketInstrumentDefinition(
      symbol: 'GLD',
      displayName: 'Gold ETF',
      badge: 'G',
      category: MarketCategory.etfs,
    ),
    MarketInstrumentDefinition(
      symbol: 'USO',
      displayName: 'Oil Fund',
      badge: 'O',
      category: MarketCategory.etfs,
    ),
  ];
}
