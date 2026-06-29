import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockubl/app/theme/app_spacing.dart';
import 'package:stockubl/features/markets/domain/market_instrument_catalog.dart';
import 'package:stockubl/features/markets/presentation/models/market_instrument_view_data.dart';
import 'package:stockubl/features/markets/presentation/widgets/market_category_selector.dart';
import 'package:stockubl/features/markets/presentation/widgets/market_data_status.dart';
import 'package:stockubl/features/markets/presentation/widgets/market_instrument_card.dart';
import 'package:stockubl/features/markets/presentation/widgets/market_search_field.dart';
import 'package:stockubl/shared/market_data/application/market_data_controller.dart';
import 'package:stockubl/shared/presentation/components/app_header_action.dart';
import 'package:stockubl/shared/presentation/layouts/app_tab_page.dart';

class MarketsScreen extends ConsumerStatefulWidget {
  const MarketsScreen({super.key});

  @override
  ConsumerState<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends ConsumerState<MarketsScreen> {
  final _searchController = TextEditingController();
  MarketCategory _selectedCategory = MarketCategory.popular;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final marketState = ref.watch(marketDataControllerProvider);
    final query = _query.trim().toLowerCase();
    final instruments = MarketInstrumentViewData.fromDefinitions(
      definitions: MarketInstrumentCatalog.popular.where((instrument) {
        final matchesCategory =
            _selectedCategory == MarketCategory.popular ||
            instrument.category == _selectedCategory;
        final matchesQuery =
            query.isEmpty ||
            instrument.symbol.toLowerCase().contains(query) ||
            instrument.displayName.toLowerCase().contains(query);
        return matchesCategory && matchesQuery;
      }),
      state: marketState,
    );

    return AppTabPage(
      title: 'Markets',
      subtitle: '',
      bottomPadding: AppSpacing.sm,
      actions: [
        AppHeaderAction(
          icon: Icons.notifications_outlined,
          tooltip: 'Market alerts',
          showIndicator: true,
          onPressed: () {},
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MarketCategorySelector(
            selected: _selectedCategory,
            onSelected: (category) {
              setState(() => _selectedCategory = category);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          MarketSearchField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: AppSpacing.md),
          const _TradeActionRow(),
          const SizedBox(height: AppSpacing.sm),
          MarketDataStatus(status: marketState.streamStatus),
          if (marketState.lastFailure != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _MarketFailureBanner(message: marketState.lastFailure!.message),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedCategory == MarketCategory.popular
                      ? 'Popular instruments'
                      : _selectedCategory.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                '${instruments.length} instruments',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: instruments.isEmpty
                ? const _NoMarketResults()
                : ListView(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    children: [MarketInstrumentCard(instruments: instruments)],
                  ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const _StartTradingButton(),
        ],
      ),
    );
  }
}

class _MarketFailureBanner extends StatelessWidget {
  const _MarketFailureBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.error.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: colors.onErrorContainer,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onErrorContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeActionRow extends StatelessWidget {
  const _TradeActionRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _DisabledTradeButton(
            label: 'Buy',
            icon: Icons.trending_up_rounded,
            isPrimary: true,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _DisabledTradeButton(
            label: 'Sell',
            icon: Icons.trending_down_rounded,
            isPrimary: false,
          ),
        ),
      ],
    );
  }
}

class _DisabledTradeButton extends StatelessWidget {
  const _DisabledTradeButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      button: true,
      enabled: false,
      label: '$label disabled',
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? colors.primary : colors.primaryContainer,
          borderRadius: BorderRadius.circular(18),
          border: isPrimary ? null : Border.all(color: colors.outlineVariant),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? colors.onPrimary : colors.primary,
              size: 22,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isPrimary ? colors.onPrimary : colors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StartTradingButton extends StatelessWidget {
  const _StartTradingButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      button: true,
      enabled: false,
      label: 'Start Trading disabled',
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start Trading',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.onPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.arrow_forward_rounded,
              color: colors.onPrimary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoMarketResults extends StatelessWidget {
  const _NoMarketResults();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 40,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('No matching instruments', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
