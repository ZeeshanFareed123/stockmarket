import 'package:flutter/material.dart';
import 'package:stockubl/app/settings/domain/app_font_family.dart';

abstract final class AppTypography {
  static TextTheme textTheme({
    required Brightness brightness,
    required AppFontFamily fontFamily,
  }) {
    final base = brightness == Brightness.light
        ? Typography.material2021().black
        : Typography.material2021().white;
    final themed = base.apply(fontFamily: fontFamily.familyName);

    return themed.copyWith(
      headlineLarge: themed.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
      ),
      headlineMedium: themed.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.7,
      ),
      headlineSmall: themed.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      titleLarge: themed.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: themed.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: themed.bodyLarge?.copyWith(height: 1.4),
      bodyMedium: themed.bodyMedium?.copyWith(height: 1.4),
      labelLarge: themed.labelLarge?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
