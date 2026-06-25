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

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: MarketCategory.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final category = MarketCategory.values[index];
          final isSelected = category == selected;

          return InkWell(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            onTap: () => onSelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primaryContainer
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Row(
                children: [
                  if (category == MarketCategory.popular) ...[
                    Icon(
                      Icons.star_outline_rounded,
                      color: isSelected
                          ? colors.primary
                          : colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Text(
                    category.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isSelected
                          ? colors.primary
                          : colors.onSurfaceVariant,
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
    );
  }
}
