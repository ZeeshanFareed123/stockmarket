import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockubl/app/theme/app_colors.dart';
import 'package:stockubl/app/theme/app_radius.dart';
import 'package:stockubl/app/theme/app_spacing.dart';
import 'package:stockubl/features/markets/presentation/models/market_instrument_view_data.dart';
import 'package:stockubl/features/markets/presentation/widgets/market_sparkline.dart';

class MarketInstrumentCard extends StatelessWidget {
  const MarketInstrumentCard({
    required this.instruments,
    required this.watchlist,
    required this.onWatchlistChanged,
    super.key,
  });

  final List<MarketInstrumentViewData> instruments;
  final Set<String> watchlist;
  final ValueChanged<String> onWatchlistChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        children: [
          for (var index = 0; index < instruments.length; index++) ...[
            MarketInstrumentRow(
              instrument: instruments[index],
              isSaved: watchlist.contains(instruments[index].definition.symbol),
              onSavePressed: () =>
                  onWatchlistChanged(instruments[index].definition.symbol),
            ),
            if (index != instruments.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Divider(color: colors.outlineVariant),
              ),
          ],
        ],
      ),
    );
  }
}

class MarketInstrumentRow extends StatelessWidget {
  const MarketInstrumentRow({
    required this.instrument,
    required this.isSaved,
    required this.onSavePressed,
    super.key,
  });

  final MarketInstrumentViewData instrument;
  final bool isSaved;
  final VoidCallback onSavePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final movementColor = instrument.isPositive
        ? AppColors.gain
        : instrument.isNegative
        ? AppColors.loss
        : colors.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          _InstrumentBadge(
            label: instrument.definition.badge,
            isLive: instrument.isLive,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  instrument.definition.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  instrument.definition.symbol,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _updatedLabel(instrument),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: instrument.isLive
                        ? AppColors.gain
                        : colors.onSurfaceVariant,
                    fontWeight: instrument.isLive
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: MarketSparkline(
                values: instrument.priceSeries,
                color: movementColor,
              ),
            ),
          ),
          SizedBox(
            width: 92,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (instrument.isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Text(
                    _formatPrice(instrument),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _formatPercent(instrument),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: movementColor,
                    fontWeight: FontWeight.w600,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            tooltip: isSaved ? 'Remove from watchlist' : 'Add to watchlist',
            onPressed: onSavePressed,
            icon: Icon(
              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isSaved ? colors.primary : colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _updatedLabel(MarketInstrumentViewData data) {
    if (data.isLive) {
      return 'Live now';
    }
    final updatedAt = data.updatedAt;
    if (updatedAt == null) {
      return data.isLoading ? 'Loading...' : 'Waiting for data';
    }

    final difference = DateTime.now().toUtc().difference(updatedAt);
    if (difference.inMinutes < 1) {
      return 'Updated just now';
    }
    if (difference.inHours < 1) {
      return 'Updated ${difference.inMinutes}m ago';
    }
    if (difference.inHours < 24) {
      return 'Updated ${difference.inHours}h ago';
    }
    return 'Updated ${DateFormat.MMMd().format(updatedAt.toLocal())}';
  }

  String _formatPrice(MarketInstrumentViewData data) {
    final price = data.price;
    if (price == null) {
      return '—';
    }
    final value = double.tryParse(price.toString()) ?? 0;
    final decimals = value < 1 ? 4 : 2;
    return NumberFormat.currency(
      symbol: r'$',
      decimalDigits: decimals,
    ).format(value);
  }

  String _formatPercent(MarketInstrumentViewData data) {
    final value = data.percentChange;
    if (value == null) {
      return '—';
    }
    final number = double.tryParse(value.toString()) ?? 0;
    final sign = number > 0 ? '+' : '';
    return '$sign${number.toStringAsFixed(2)}%';
  }
}

class _InstrumentBadge extends StatelessWidget {
  const _InstrumentBadge({required this.label, required this.isLive});

  final String label;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Badge(
      isLabelVisible: isLive,
      backgroundColor: AppColors.gain,
      smallSize: 8,
      child: Container(
        width: 54,
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
