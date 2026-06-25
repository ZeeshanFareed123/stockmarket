import 'package:stockubl/app/settings/domain/app_settings.dart';

abstract interface class AppSettingsRepository {
  AppSettings load();

  Future<void> save(AppSettings settings);
}
