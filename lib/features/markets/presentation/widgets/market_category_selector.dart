import 'package:flutter/material.dart';
import 'package:stockubl/app/theme/app_radius.dart';
import 'package:stockubl/app/theme/app_spacing.dart';
import 'package:stockubl/features/markets/domain/market_instrument_catalog.dart';

class MarketCategorySelector extends StatelessWidget {
  const MarketCategorySelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final MarketCategory selected;
  final ValueChanged<MarketCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final labelStyle = theme.textTheme.titleSmall;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: colors.outline),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final category in MarketCategory.values) ...[
              Builder(
                builder: (context) {
                  final isSelected = category == selected;
                  final foreground = isSelected
                      ? colors.primary
                      : colors.onSurfaceVariant;

                  return InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    onTap: () => onSelected(category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primaryContainer
                            : colors.primaryContainer.withValues(alpha: 0),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (category == MarketCategory.popular) ...[
                            Icon(
                              Icons.star_outline_rounded,
                              size: (labelStyle?.fontSize ?? 14) + 2,
                              color: foreground,
                            ),
                            const SizedBox(width: AppSpacing.xxs),
                          ],
                          Text(
                            category.label,
                            style: labelStyle?.copyWith(
                              color: foreground,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (category != MarketCategory.values.last)
                const SizedBox(width: AppSpacing.xxs),
            ],
          ],
        ),
      ),
    );
  }
}
