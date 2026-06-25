import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockubl/app/router/app_router.dart';
import 'package:stockubl/core/di/external_dependencies.dart';

void main() {
  testWidgets('start opens the main shell and switches tabs', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        child: Consumer(
          builder: (context, ref, child) {
            return MaterialApp.router(
              routerConfig: ref.watch(appRouterProvider),
            );
          },
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Start'));
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    expect(find.text('Home dashboard'), findsOneWidget);

    await tester.tap(find.text('Markets'));
    await tester.pumpAndSettle();
    expect(find.text('Explore the markets'), findsOneWidget);

    await tester.tap(find.text('Portfolio'));
    await tester.pumpAndSettle();
    expect(find.text('Your portfolio'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Color theme'), findsOneWidget);
    expect(find.byTooltip('Profile'), findsOneWidget);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(preferences.getString('appearance.theme_mode'), 'dark');

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Typography'), findsOneWidget);
  });
}
