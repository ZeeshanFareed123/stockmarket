import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stockubl/app/settings/data/app_settings_repository_provider.dart';
import 'package:stockubl/app/settings/domain/app_color_palette.dart';
import 'package:stockubl/app/settings/domain/app_font_family.dart';
import 'package:stockubl/app/settings/domain/app_settings.dart';

part 'app_settings_controller.g.dart';

@Riverpod(keepAlive: true)
class AppSettingsController extends _$AppSettingsController {
  @override
  AppSettings build() {
    return ref.read(appSettingsRepositoryProvider).load();
  }

  Future<void> setThemeMode(ThemeMode value) {
    return _update(state.copyWith(themeMode: value));
  }

  Future<void> setColorPalette(AppColorPalette value) {
    return _update(state.copyWith(colorPalette: value));
  }

  Future<void> setFontFamily(AppFontFamily value) {
    return _update(state.copyWith(fontFamily: value));
  }

  Future<void> setTextScaleFactor(double value) {
    return _update(state.copyWith(textScaleFactor: value.clamp(0.8, 1.4)));
  }

  Future<void> reset() {
    return _update(const AppSettings());
  }

  Future<void> _update(AppSettings next) async {
    state = next;
    await ref.read(appSettingsRepositoryProvider).save(next);
  }
}
