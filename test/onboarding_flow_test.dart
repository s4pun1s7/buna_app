import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buna_app/features/onboarding/onboarding_screen.dart';
import 'package:buna_app/navigation/route_guards.dart';

void main() {
  group('Onboarding Flow Tests', () {
    setUpAll(() async {
      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
    });

    tearDownAll(() async {
      // Clean up
      await RouteGuards.resetOnboardingStatus();
    });

    testWidgets('Onboarding screen shows language selection and get started button', (WidgetTester tester) async {
      // Reset onboarding status to ensure we start fresh
      await RouteGuards.resetOnboardingStatus();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const OnboardingScreen(),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify language selection chips are present
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Български'), findsOneWidget);

      // Verify welcome text is present
      expect(find.text('Welcome to Buna Festival'), findsOneWidget);

      // Verify get started button is present
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('Language selection works correctly', (WidgetTester tester) async {
      await RouteGuards.resetOnboardingStatus();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const OnboardingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially English should be selected (first ChoiceChip)
      final englishChip = tester.widget<ChoiceChip>(find.byType(ChoiceChip).first);
      final bulgarianChip = tester.widget<ChoiceChip>(find.byType(ChoiceChip).last);
      
      expect(englishChip.selected, isTrue);
      expect(bulgarianChip.selected, isFalse);

      // Tap Bulgarian
      await tester.tap(find.text('Български'));
      await tester.pumpAndSettle();

      // Now Bulgarian should be selected
      final englishChipAfter = tester.widget<ChoiceChip>(find.byType(ChoiceChip).first);
      final bulgarianChipAfter = tester.widget<ChoiceChip>(find.byType(ChoiceChip).last);
      
      expect(englishChipAfter.selected, isFalse);
      expect(bulgarianChipAfter.selected, isTrue);
    });

    testWidgets('Get started button shows loading state when tapped', (WidgetTester tester) async {
      await RouteGuards.resetOnboardingStatus();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const OnboardingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially should show "Get Started"
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('Loading...'), findsNothing);

      // Tap get started button
      await tester.tap(find.text('Get Started'));
      await tester.pump();

      // Should show loading state
      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    test('Onboarding status is properly managed', () async {
      // Reset to ensure clean state
      await RouteGuards.resetOnboardingStatus();

      // Initially should not be completed
      expect(await RouteGuards.hasCompletedOnboarding(), isFalse);

      // Mark as completed
      await RouteGuards.markOnboardingCompleted();

      // Should now be completed
      expect(await RouteGuards.hasCompletedOnboarding(), isTrue);

      // Reset again
      await RouteGuards.resetOnboardingStatus();
      expect(await RouteGuards.hasCompletedOnboarding(), isFalse);
    });

    test('Onboarding completion flow works correctly', () async {
      // Reset to ensure clean state
      await RouteGuards.resetOnboardingStatus();

      // Initially should not be completed
      expect(await RouteGuards.hasCompletedOnboarding(), isFalse);

      // Mark as completed
      await RouteGuards.markOnboardingCompleted();

      // Should now be completed
      expect(await RouteGuards.hasCompletedOnboarding(), isTrue);

      // Verify the value is persisted
      final prefs = await SharedPreferences.getInstance();
      final status = prefs.getBool('has_completed_onboarding');
      expect(status, isTrue);
    });
  });
} 