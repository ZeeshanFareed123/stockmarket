import 'package:flutter/material.dart';
import 'package:stockubl/app/settings/domain/app_color_palette.dart';
import 'package:stockubl/app/settings/domain/app_font_family.dart';

@immutable
final class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.colorPalette = AppColorPalette.indigo,
    this.fontFamily = AppFontFamily.sansSerif,
    this.textScaleFactor = 1,
  });

  final ThemeMode themeMode;
  final AppColorPalette colorPalette;
  final AppFontFamily fontFamily;
  final double textScaleFactor;

  AppSettings copyWith({
    ThemeMode? themeMode,
    AppColorPalette? colorPalette,
    AppFontFamily? fontFamily,
    double? textScaleFactor,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      colorPalette: colorPalette ?? this.colorPalette,
      fontFamily: fontFamily ?? this.fontFamily,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    );
  }
}
