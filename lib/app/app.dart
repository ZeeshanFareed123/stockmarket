import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockubl/app/config/app_config_provider.dart';
import 'package:stockubl/app/router/app_router.dart';
import 'package:stockubl/app/settings/application/app_settings_controller.dart';
import 'package:stockubl/app/theme/app_scroll_behavior.dart';
import 'package:stockubl/app/theme/app_theme.dart';
import 'package:stockubl/shared/market_data/presentation/market_data_lifecycle_host.dart';

class StockUblApp extends ConsumerWidget {
  const StockUblApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(appSettingsControllerProvider);

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: AppTheme.light(
        palette: settings.colorPalette,
        fontFamily: settings.fontFamily,
      ),
      darkTheme: AppTheme.dark(
        palette: settings.colorPalette,
        fontFamily: settings.fontFamily,
      ),
      scrollBehavior: const AppScrollBehavior(),
      routerConfig: router,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final systemScale = mediaQuery.textScaler.scale(16) / 16;
        final effectiveScale = (systemScale * settings.textScaleFactor).clamp(
          0.8,
          2.0,
        );

        return MarketDataLifecycleHost(
          child: MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: TextScaler.linear(effectiveScale),
            ),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
