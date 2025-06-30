import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buna_app/navigation/route_guards.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('Onboarding Tests', () {
    setUp(() async {
      // Clear any existing preferences before each test
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('has_completed_onboarding');
    });

    test('should start with onboarding not completed', () async {
      final completed = await RouteGuards.hasCompletedOnboarding();
      expect(completed, false);
    });

    test('should mark onboarding as completed', () async {
      await RouteGuards.markOnboardingCompleted();
      final completed = await RouteGuards.hasCompletedOnboarding();
      expect(completed, true);
    });

    test('should reset onboarding status', () async {
      // First mark as completed
      await RouteGuards.markOnboardingCompleted();
      expect(await RouteGuards.hasCompletedOnboarding(), true);
      
      // Then reset
      await RouteGuards.resetOnboardingStatus();
      expect(await RouteGuards.hasCompletedOnboarding(), false);
    });
  });
} 