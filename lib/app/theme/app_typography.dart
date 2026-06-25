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

    return base
        .apply(fontFamily: fontFamily.familyName)
        .copyWith(
          headlineLarge: base.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
          headlineMedium: base.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          bodyLarge: base.bodyLarge?.copyWith(height: 1.45),
          bodyMedium: base.bodyMedium?.copyWith(height: 1.45),
          labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        );
  }
}
