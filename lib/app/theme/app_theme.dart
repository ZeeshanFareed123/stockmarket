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
    final seed = AppColors.seed(palette);
    final surface = isLight
        ? AppColors.lightSurface(palette)
        : AppColors.darkSurface(palette);
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    ).copyWith(surface: surface);
    final outline = scheme.outlineVariant.withValues(alpha: 0.65);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: surface,
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
          side: BorderSide(color: outline),
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
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: outline),
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
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    );
  }
}
