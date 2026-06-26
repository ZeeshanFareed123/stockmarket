import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockubl/app/theme/app_colors.dart';
import 'package:stockubl/app/theme/app_radius.dart';
import 'package:stockubl/app/theme/app_spacing.dart';
import 'package:stockubl/features/markets/presentation/models/market_instrument_view_data.dart';
import 'package:stockubl/features/markets/presentation/widgets/market_sparkline.dart';

class MarketInstrumentCard extends StatelessWidget {
  const MarketInstrumentCard({required this.instruments, super.key});

  final List<MarketInstrumentViewData> instruments;

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
            MarketInstrumentRow(instrument: instruments[index]),
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
  const MarketInstrumentRow({required this.instrument, super.key});

  final MarketInstrumentViewData instrument;

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
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
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
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: MarketSparkline(
                values: instrument.priceSeries,
                color: movementColor,
              ),
            ),
          ),
          SizedBox(
            width: 104,
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
                  _PriceHighlight(
                    key: ValueKey(instrument.definition.symbol),
                    price: _formatPrice(instrument),
                    priceValue: instrument.price,
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

class _PriceHighlight extends StatefulWidget {
  const _PriceHighlight({
    super.key,
    required this.price,
    required this.priceValue,
  });

  final String price;
  final Decimal? priceValue;

  @override
  State<_PriceHighlight> createState() => _PriceHighlightState();
}

class _PriceHighlightState extends State<_PriceHighlight> {
  Color? _flashColor;
  Timer? _hideTimer;

  @override
  void didUpdateWidget(covariant _PriceHighlight oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previous = oldWidget.priceValue;
    final current = widget.priceValue;

    if (previous == null || current == null || previous == current) {
      return;
    }

    _hideTimer?.cancel();
    setState(() {
      _flashColor = current > previous ? AppColors.gain : AppColors.loss;
    });
    _hideTimer = Timer(const Duration(milliseconds: 950), () {
      if (mounted) {
        setState(() => _flashColor = null);
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final flashColor = _flashColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: flashColor?.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Text(
        widget.price,
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
        textAlign: TextAlign.end,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
