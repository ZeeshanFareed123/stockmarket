import 'package:decimal/decimal.dart';

/// Snapshot of the signed-in customer's portfolio shown on the Home tab.
///
/// Backed by mock data today (see [PortfolioOverviewCatalog.demo]); when the
/// portfolio API is wired this will be produced by a repository under
/// `features/home/data`.
final class PortfolioOverview {
  const PortfolioOverview({
    required this.totalValueLabel,
    required this.todayChangeLabel,
    required this.trend,
    required this.watchlistSymbols,
  });

  final String totalValueLabel;
  final String todayChangeLabel;
  final List<Decimal> trend;
  final Set<String> watchlistSymbols;
}

abstract final class PortfolioOverviewCatalog {
  static final demo = PortfolioOverview(
    totalValueLabel: r'$24,860.40',
    todayChangeLabel: r'Today +$184.20',
    watchlistSymbols: const {'AAPL', 'TSLA', 'QQQ'},
    trend: _series(const [
      '24.12',
      '24.30',
      '24.24',
      '24.36',
      '24.32',
      '24.48',
      '24.44',
      '24.59',
      '24.53',
      '24.67',
      '24.72',
      '24.84',
      '24.78',
      '24.90',
      '24.86',
    ]),
  );

  static List<Decimal> _series(List<String> values) =>
      values.map(Decimal.parse).toList(growable: false);
}
