import 'package:flutter/material.dart';
import 'package:stockubl/app/settings/domain/app_color_palette.dart';

abstract final class AppColors {
  static const gain = Color(0xFF159B5B);
  static const loss = Color(0xFFD94B55);
  static const warning = Color(0xFFD18B2C);

  static Color seed(AppColorPalette palette) {
    return switch (palette) {
      AppColorPalette.indigo => const Color(0xFF4F5BD5),
      AppColorPalette.graphiteGold => const Color(0xFF9C7540),
      AppColorPalette.teal => const Color(0xFF087F73),
      AppColorPalette.plum => const Color(0xFF765287),
      AppColorPalette.coral => const Color(0xFFD76455),
    };
  }

  static Color lightSurface(AppColorPalette palette) {
    return switch (palette) {
      AppColorPalette.graphiteGold => const Color(0xFFFAF8F3),
      _ => const Color(0xFFF7F7FA),
    };
  }

  static Color darkSurface(AppColorPalette palette) {
    return switch (palette) {
      AppColorPalette.graphiteGold => const Color(0xFF1D1B18),
      _ => const Color(0xFF11131A),
    };
  }
}
