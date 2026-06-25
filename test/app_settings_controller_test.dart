import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockubl/app/settings/application/app_settings_controller.dart';
import 'package:stockubl/app/settings/domain/app_color_palette.dart';
import 'package:stockubl/app/settings/domain/app_font_family.dart';
import 'package:stockubl/core/di/external_dependencies.dart';

void main() {
  test('appearance settings update centrally and persist', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
    );
    addTearDown(container.dispose);

    final controller = container.read(appSettingsControllerProvider.notifier);

    await controller.setThemeMode(ThemeMode.dark);
    await controller.setColorPalette(AppColorPalette.teal);
    await controller.setFontFamily(AppFontFamily.serif);
    await controller.setTextScaleFactor(1.2);

    final settings = container.read(appSettingsControllerProvider);
    expect(settings.themeMode, ThemeMode.dark);
    expect(settings.colorPalette, AppColorPalette.teal);
    expect(settings.fontFamily, AppFontFamily.serif);
    expect(settings.textScaleFactor, 1.2);

    expect(preferences.getString('appearance.theme_mode'), 'dark');
    expect(preferences.getString('appearance.color_palette'), 'teal');
    expect(preferences.getString('appearance.font_family'), 'serif');
    expect(preferences.getDouble('appearance.text_scale_factor'), 1.2);
  });
}
