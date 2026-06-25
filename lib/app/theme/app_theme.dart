import 'package:flutter/material.dart';
import 'package:stockubl/app/settings/domain/app_color_palette.dart';
import 'package:stockubl/app/settings/domain/app_font_family.dart';
import 'package:stockubl/app/theme/app_colors.dart';
import 'package:stockubl/app/theme/app_radius.dart';
import 'package:stockubl/app/theme/app_spacing.dart';
import 'package:stockubl/app/theme/app_typography.dart';

abstract final class AppTheme {
  static ThemeData light({
    required AppColorPalette palette,
    required AppFontFamily fontFamily,
  }) {
    return _build(
      brightness: Brightness.light,
      palette: palette,
      fontFamily: fontFamily,
    );
  }

  static ThemeData dark({
    required AppColorPalette palette,
    required AppFontFamily fontFamily,
  }) {
    return _build(
      brightness: Brightness.dark,
      palette: palette,
      fontFamily: fontFamily,
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required AppColorPalette palette,
    required AppFontFamily fontFamily,
  }) {
    final isLight = brightness == Brightness.light;
    final scheme = isLight
        ? AppColors.lightScheme(palette)
        : AppColors.darkScheme(palette);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      splashFactory: InkRipple.splashFactory,
      textTheme: AppTypography.textTheme(
        brightness: brightness,
        fontFamily: fontFamily,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
          side: BorderSide(color: scheme.outline),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 76,
        elevation: 0,
        backgroundColor: Colors.transparent,
        indicatorColor: scheme.primaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
            size: 27,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 12,
          );
        }),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.onSurface,
          backgroundColor: scheme.surfaceContainerLowest,
          side: BorderSide(color: scheme.outline),
          minimumSize: const Size.square(48),
          shape: const CircleBorder(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.primaryContainer,
        thumbColor: scheme.primary,
        overlayColor: scheme.primary.withValues(alpha: 0.1),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    );
  }
}
