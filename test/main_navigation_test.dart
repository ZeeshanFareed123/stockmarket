import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockubl/app/router/app_router.dart';

void main() {
  testWidgets('start opens the main shell and switches tabs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
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
    expect(find.text('App settings'), findsOneWidget);
    expect(find.byTooltip('Profile'), findsOneWidget);
  });
}
