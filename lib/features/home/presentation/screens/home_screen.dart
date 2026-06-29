import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stockubl/app/router/app_routes.dart';
import 'package:stockubl/app/theme/app_radius.dart';
import 'package:stockubl/app/theme/app_spacing.dart';
import 'package:stockubl/features/home/domain/portfolio_overview.dart';
import 'package:stockubl/features/markets/domain/market_instrument_catalog.dart';
import 'package:stockubl/features/markets/presentation/models/market_instrument_view_data.dart';
import 'package:stockubl/features/markets/presentation/widgets/market_instrument_card.dart';
import 'package:stockubl/features/markets/presentation/widgets/market_sparkline.dart';
import 'package:stockubl/shared/market_data/application/market_data_controller.dart';
import 'package:stockubl/shared/presentation/components/app_header_action.dart';
import 'package:stockubl/shared/presentation/feedback/app_snackbar.dart';
import 'package:stockubl/shared/presentation/layouts/app_tab_page.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  _HomeAction _selectedAction = _HomeAction.buy;

  void _selectAction(_HomeAction action) {
    setState(() => _selectedAction = action);
    _showComingSoon(action.label);
  }

  void _showComingSoon(String feature) {
    AppSnackbar.info(context, '$feature is not implemented yet.');
  }

  @override
  Widget build(BuildContext context) {
    final overview = PortfolioOverviewCatalog.demo;
    final marketState = ref.watch(marketDataControllerProvider);
    final watchlist = MarketInstrumentViewData.fromDefinitions(
      definitions: MarketInstrumentCatalog.popular.where(
        (instrument) => overview.watchlistSymbols.contains(instrument.symbol),
      ),
      state: marketState,
    );

    return AppTabPage(
      title: 'Hi Zeeshan',
      subtitle: 'Open',
      showStatusIndicator: true,
      bottomPadding: AppSpacing.sm,
      actions: [
        _ProfileBadge(onTap: () => _showComingSoon('Profile')),
        AppHeaderAction(
          icon: Icons.notifications_outlined,
          tooltip: 'Notifications',
          showIndicator: true,
          onPressed: () => _showComingSoon('Notifications'),
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        children: [
          _PortfolioSummaryCard(overview: overview),
          const SizedBox(height: AppSpacing.md),
          _QuickActionRow(
            selectedAction: _selectedAction,
            onSelected: _selectAction,
          ),
          if (watchlist.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            const _SectionHeader(title: 'My watchlist'),
            const SizedBox(height: AppSpacing.sm),
            MarketInstrumentCard(instruments: watchlist),
          ],
          const SizedBox(height: AppSpacing.lg),
          const _SectionHeader(title: 'Recent activity'),
          const SizedBox(height: AppSpacing.sm),
          const _RecentActivityMessage(),
        ],
      ),
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  const _ProfileBadge({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          shape: BoxShape.circle,
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Icon(Icons.person_rounded, color: colors.primary, size: 28),
      ),
    );
  }
}

class _PortfolioSummaryCard extends StatelessWidget {
  const _PortfolioSummaryCard({required this.overview});

  final PortfolioOverview overview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          colors.primary.withValues(alpha: 0.08),
          colors.surfaceContainerLowest,
        ),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: colors.primary.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chartWidth = constraints.maxWidth < 330 ? 112.0 : 148.0;

          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portfolio value',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        overview.totalValueLabel,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      overview.todayChangeLabel,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.small),
                      onTap: () => context.go(AppRoute.portfolio.path),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xxs,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View portfolio',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: colors.primary,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: chartWidth,
                height: 76,
                child: MarketSparkline(
                  values: overview.trend,
                  color: colors.primary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  const _QuickActionRow({
    required this.selectedAction,
    required this.onSelected,
  });

  final _HomeAction selectedAction;
  final ValueChanged<_HomeAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final action in _HomeAction.values) ...[
          Expanded(
            child: _QuickActionCard(
              action: action,
              isSelected: selectedAction == action,
              onTap: () => onSelected(action),
            ),
          ),
          if (action != _HomeAction.values.last)
            const SizedBox(width: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.action,
    required this.isSelected,
    required this.onTap,
  });

  final _HomeAction action;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final foreground = isSelected ? colors.onPrimary : colors.primary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: action.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : colors.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: isSelected
                ? null
                : Border.all(color: colors.outlineVariant),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, color: foreground, size: 26),
              const SizedBox(height: AppSpacing.xs),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  action.label,
                  maxLines: 1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
        Text(
          'View all',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: AppSpacing.xxs),
        Icon(Icons.chevron_right_rounded, color: colors.primary, size: 20),
      ],
    );
  }
}

class _RecentActivityMessage extends StatelessWidget {
  const _RecentActivityMessage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text(
        'No recent activity',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: colors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

enum _HomeAction {
  buy('Buy', Icons.trending_up_rounded),
  sell('Sell', Icons.trending_down_rounded),
  deposit('Deposit', Icons.account_balance_wallet_outlined),
  withdraw('Withdraw', Icons.upload_rounded);

  const _HomeAction(this.label, this.icon);

  final String label;
  final IconData icon;
}
