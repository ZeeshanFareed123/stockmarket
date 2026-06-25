import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stockubl/app/navigation/presentation/main_shell.dart';
import 'package:stockubl/app/router/app_routes.dart';
import 'package:stockubl/features/auth/presentation/screens/login_screen.dart';
import 'package:stockubl/features/home/presentation/screens/home_screen.dart';
import 'package:stockubl/features/markets/presentation/screens/markets_screen.dart';
import 'package:stockubl/features/portfolio/presentation/screens/portfolio_screen.dart';
import 'package:stockubl/features/settings/presentation/screens/settings_screen.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoute.login.path,
    routes: [
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.home.path,
                name: AppRoute.home.name,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.markets.path,
                name: AppRoute.markets.name,
                builder: (context, state) => const MarketsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.portfolio.path,
                name: AppRoute.portfolio.name,
                builder: (context, state) => const PortfolioScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.settings.path,
                name: AppRoute.settings.name,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
