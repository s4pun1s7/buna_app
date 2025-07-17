import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buna_app/widgets/onboarding/onboarding_step.dart';

import 'firebase_test_mocks.dart';

void main() {
  setUpAll(() async {
    await setupFirebaseTestMocks();
  });
  group('OnboardingStep Widget', () {
    testWidgets('displays title, description, and next button', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingStep(
              title: 'Test Title',
              description: 'Test Description',
              onNext: () => pressed = true,
              isLast: false,
            ),
          ),
        ),
      );
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      await tester.tap(find.text('Next'));
      expect(pressed, isTrue);
    });
    testWidgets('shows Done on last step', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingStep(
              title: 'Final',
              description: 'Last step',
              onNext: () {},
              isLast: true,
            ),
          ),
        ),
      );
      expect(find.text('Done'), findsOneWidget);
    });
  });
}
