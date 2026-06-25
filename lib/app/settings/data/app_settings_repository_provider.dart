import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stockubl/app/settings/data/shared_preferences_app_settings_repository.dart';
import 'package:stockubl/app/settings/domain/app_settings_repository.dart';
import 'package:stockubl/core/di/external_dependencies.dart';

part 'app_settings_repository_provider.g.dart';

@Riverpod(keepAlive: true)
AppSettingsRepository appSettingsRepository(Ref ref) {
  return SharedPreferencesAppSettingsRepository(
    ref.watch(sharedPreferencesProvider),
  );
}
