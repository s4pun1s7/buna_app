import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/rendering.dart';
import 'package:buna_app/widgets/common/error_screen.dart';

void main() {
  testWidgets('ErrorScreen displays message and retry button', (tester) async {
    bool retried = false;
    await tester.pumpWidget(
      MaterialApp(
        home: AppErrorWidget(
          message: 'Something went wrong',
          onRetry: () => retried = true,
        ),
      ),
    );
    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    // Accessibility: Check semantics
    final semantics = tester.getSemantics(find.text('Retry'));
    expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);

    // Tap retry
    await tester.tap(find.text('Retry'));
    expect(retried, isTrue);
  });
} 