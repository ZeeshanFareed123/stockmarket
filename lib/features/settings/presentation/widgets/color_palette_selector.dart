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
    const spacing = AppSpacing.sm;
    const columns = 5;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: AppColorPalette.values
              .map((palette) {
                return _PaletteOption(
                  palette: palette,
                  isSelected: palette == value,
                  width: itemWidth,
                  onTap: () => onChanged(palette),
                );
              })
              .toList(growable: false),
        );
      },
    );
  }
}

class _PaletteOption extends StatelessWidget {
  const _PaletteOption({
    required this.palette,
    required this.isSelected,
    required this.width,
    required this.onTap,
  });

  final AppColorPalette palette;
  final bool isSelected;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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
          width: width,
          height: 52,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(AppSpacing.xs),
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
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.22), blurRadius: 10),
              ],
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 17)
                : null,
          ),
        ),
      ),
    );
  }
}
