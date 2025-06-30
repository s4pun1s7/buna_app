import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buna_app/widgets/error_screen.dart';
import 'package:buna_app/services/error_handler.dart';

void main() {
  group('ErrorScreen', () {
    testWidgets('displays default error message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ErrorScreen(error: AppException('Test error'))),
        ),
      );
      expect(find.text('Test error'), findsOneWidget);
    });

    testWidgets('calls onRetry when retry button is pressed', (tester) async {
      bool retried = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorScreen(
              error: AppException('Custom error'),
              onRetry: () => retried = true,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Try Again'));
      expect(retried, isTrue);
    });
  });
}
