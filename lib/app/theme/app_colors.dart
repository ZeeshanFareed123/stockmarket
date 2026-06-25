import 'package:flutter/material.dart';
import 'package:stockubl/app/settings/domain/app_color_palette.dart';

abstract final class AppColors {
  static const gain = Color(0xFF159B5B);
  static const loss = Color(0xFFD94B55);
  static const warning = Color(0xFFD18B2C);
  static const lightBackground = Color(0xFFFAFAFE);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightText = Color(0xFF0B1238);
  static const lightMutedText = Color(0xFF707796);
  static const lightOutline = Color(0xFFE5E7F1);
  static const darkBackground = Color(0xFF0B1020);
  static const darkSurface = Color(0xFF131A2D);
  static const darkText = Color(0xFFF7F8FF);
  static const darkMutedText = Color(0xFFAEB4CB);
  static const darkOutline = Color(0xFF2A324A);

  static Color seed(AppColorPalette palette) {
    return switch (palette) {
      AppColorPalette.indigo => const Color(0xFF3F46F4),
      AppColorPalette.graphiteGold => const Color(0xFF9C7540),
      AppColorPalette.teal => const Color(0xFF087F73),
      AppColorPalette.plum => const Color(0xFF765287),
      AppColorPalette.coral => const Color(0xFFD76455),
    };
  }

  static ColorScheme lightScheme(AppColorPalette palette) {
    final primary = seed(palette);
    final generated = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    );

    return generated.copyWith(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: _tint(primary, 0.11),
      onPrimaryContainer: primary,
      surface: lightBackground,
      onSurface: lightText,
      surfaceContainerLowest: lightSurface,
      surfaceContainerLow: const Color(0xFFF7F7FD),
      surfaceContainer: const Color(0xFFF1F1FB),
      surfaceContainerHigh: const Color(0xFFEAEAF7),
      onSurfaceVariant: lightMutedText,
      outline: lightOutline,
      outlineVariant: const Color(0xFFEEF0F7),
      shadow: const Color(0xFF10152E),
    );
  }

  static ColorScheme darkScheme(AppColorPalette palette) {
    final seedColor = seed(palette);
    final generated = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
    final primary = generated.primary;

    return generated.copyWith(
      primary: primary,
      onPrimary: const Color(0xFF081022),
      primaryContainer: _shade(seedColor, 0.34),
      onPrimaryContainer: const Color(0xFFE8E9FF),
      surface: darkBackground,
      onSurface: darkText,
      surfaceContainerLowest: darkSurface,
      surfaceContainerLow: const Color(0xFF171E33),
      surfaceContainer: const Color(0xFF1C243B),
      surfaceContainerHigh: const Color(0xFF232C45),
      onSurfaceVariant: darkMutedText,
      outline: darkOutline,
      outlineVariant: const Color(0xFF20283D),
      shadow: Colors.black,
    );
  }

  static Color _tint(Color color, double opacity) {
    return Color.alphaBlend(color.withValues(alpha: opacity), Colors.white);
  }

  static Color _shade(Color color, double opacity) {
    return Color.alphaBlend(color.withValues(alpha: opacity), darkSurface);
  }
}
