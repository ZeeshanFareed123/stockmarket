import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockubl/app/app.dart';
import 'package:stockubl/app/config/app_config.dart';
import 'package:stockubl/app/config/app_config_provider.dart';
import 'package:stockubl/core/di/external_dependencies.dart';

Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
      child: const StockUblApp(),
    ),
  );
}
