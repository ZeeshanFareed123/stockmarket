import 'package:flutter/material.dart';
import 'package:stockubl/app/settings/domain/app_color_palette.dart';
import 'package:stockubl/app/theme/app_colors.dart';
import 'package:stockubl/app/theme/app_radius.dart';
import 'package:stockubl/app/theme/app_spacing.dart';

class ColorPaletteSelector extends StatelessWidget {
  const ColorPaletteSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final AppColorPalette value;
  final ValueChanged<AppColorPalette> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: AppColorPalette.values
          .map((palette) {
            return _PaletteOption(
              palette: palette,
              isSelected: palette == value,
              onTap: () => onChanged(palette),
            );
          })
          .toList(growable: false),
    );
  }
}

class _PaletteOption extends StatelessWidget {
  const _PaletteOption({
    required this.palette,
    required this.isSelected,
    required this.onTap,
  });

  final AppColorPalette palette;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final color = AppColors.seed(palette);

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${palette.label} color theme',
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 96,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primaryContainer
                : colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(
              color: isSelected ? colors.primary : colors.outline,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.22),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: isSelected
                    ? const Icon(Icons.check_rounded, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                palette.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? colors.onPrimaryContainer
                      : colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
