import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buna_app/widgets/error_screen.dart';

void main() {
  group('ErrorScreen Widget', () {
    testWidgets('displays default error message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ErrorScreen())),
      );
      expect(find.text('Something went wrong.'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
    testWidgets('displays custom message and retry button', (tester) async {
      bool retried = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorScreen(
              message: 'Custom error',
              onRetry: () => retried = true,
            ),
          ),
        ),
      );
      expect(find.text('Custom error'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      expect(retried, isTrue);
    });
  });
}
