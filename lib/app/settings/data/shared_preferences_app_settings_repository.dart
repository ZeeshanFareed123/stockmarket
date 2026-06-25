import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockubl/app/settings/domain/app_color_palette.dart';
import 'package:stockubl/app/settings/domain/app_font_family.dart';
import 'package:stockubl/app/settings/domain/app_settings.dart';
import 'package:stockubl/app/settings/domain/app_settings_repository.dart';

final class SharedPreferencesAppSettingsRepository
    implements AppSettingsRepository {
  const SharedPreferencesAppSettingsRepository(this._preferences);

  static const _themeModeKey = 'appearance.theme_mode';
  static const _colorPaletteKey = 'appearance.color_palette';
  static const _fontFamilyKey = 'appearance.font_family';
  static const _textScaleFactorKey = 'appearance.text_scale_factor';

  final SharedPreferences _preferences;

  @override
  AppSettings load() {
    return AppSettings(
      themeMode: _enumByName(
        ThemeMode.values,
        _preferences.getString(_themeModeKey),
        ThemeMode.system,
      ),
      colorPalette: _enumByName(
        AppColorPalette.values,
        _preferences.getString(_colorPaletteKey),
        AppColorPalette.indigo,
      ),
      fontFamily: _enumByName(
        AppFontFamily.values,
        _preferences.getString(_fontFamilyKey),
        AppFontFamily.system,
      ),
      textScaleFactor: _preferences.getDouble(_textScaleFactorKey) ?? 1,
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    await Future.wait([
      _preferences.setString(_themeModeKey, settings.themeMode.name),
      _preferences.setString(_colorPaletteKey, settings.colorPalette.name),
      _preferences.setString(_fontFamilyKey, settings.fontFamily.name),
      _preferences.setDouble(_textScaleFactorKey, settings.textScaleFactor),
    ]);
  }

  T _enumByName<T extends Enum>(List<T> values, String? name, T fallback) {
    if (name == null) {
      return fallback;
    }

    return values.firstWhere(
      (value) => value.name == name,
      orElse: () => fallback,
    );
  }
}
