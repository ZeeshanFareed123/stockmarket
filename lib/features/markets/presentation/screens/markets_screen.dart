import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockubl/app/theme/app_spacing.dart';
import 'package:stockubl/features/markets/domain/market_instrument_catalog.dart';
import 'package:stockubl/features/markets/presentation/models/market_instrument_view_data.dart';
import 'package:stockubl/features/markets/presentation/widgets/market_category_selector.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final marketState = ref.watch(marketDataControllerProvider);
    final query = _searchController.text.trim().toLowerCase();
    final instruments = MarketInstrumentCatalog.popular
        .where((instrument) {
          final matchesCategory =
              _selectedCategory == MarketCategory.popular ||
              instrument.category == _selectedCategory;
          final matchesQuery =
              query.isEmpty ||
              instrument.displayName.toLowerCase().contains(query) ||
              instrument.symbol.toLowerCase().contains(query);
          return matchesCategory && matchesQuery;
        })
        .map(
          (definition) => MarketInstrumentViewData.fromState(
            definition: definition,
            state: marketState,
          ),
        )
        .toList(growable: false);

    return AppTabPage(
      title: 'Markets',
      subtitle: '',
      actions: [
        AppHeaderAction(
          icon: Icons.notifications_outlined,
          tooltip: 'Market alerts',
          showIndicator: true,
          onPressed: () {},
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        children: [
          MarketCategorySelector(
            selected: _selectedCategory,
            onSelected: (category) {
              setState(() => _selectedCategory = category);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          const _TradeActionRow(),
          const SizedBox(height: AppSpacing.md),
          MarketSearchField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedCategory == MarketCategory.popular
                      ? 'Popular instruments'
                      : _selectedCategory.label,
                  style: Theme.of(context).textTheme.titleLarge,
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
          if (instruments.isEmpty)
            const _NoMarketResults()
          else
            MarketInstrumentCard(instruments: instruments),
          const SizedBox(height: AppSpacing.md),
          const _StartTradingButton(),
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
        Expanded(child: _DisabledTradeButton(label: 'Buy', isPrimary: true)),
        SizedBox(width: AppSpacing.md),
        Expanded(child: _DisabledTradeButton(label: 'Sell', isPrimary: false)),
      ],
    );
  }
}

class _DisabledTradeButton extends StatelessWidget {
  const _DisabledTradeButton({required this.label, required this.isPrimary});

  final String label;
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
        height: 58,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? colors.primary : colors.primaryContainer,
          borderRadius: BorderRadius.circular(18),
          border: isPrimary ? null : Border.all(color: colors.outlineVariant),
        ),
        child: Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isPrimary ? colors.onPrimary : colors.primary,
            fontWeight: FontWeight.w800,
          ),
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
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Start Trading',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colors.onPrimary,
            fontWeight: FontWeight.w800,
          ),
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
