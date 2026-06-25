import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockubl/features/auth/presentation/screens/login_screen.dart';

void main() {
  testWidgets('login screen shows the start action', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );

    expect(find.text('StockUBL'), findsOneWidget);
    expect(find.text('Invest with clarity.'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Start'), findsOneWidget);
  });
}
