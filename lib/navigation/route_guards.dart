import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'route_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/log_service.dart';

/// Provider for onboarding status
final onboardingStatusProvider = FutureProvider<bool>((ref) async {
  LogService.debug('RouteGuards: Loading onboarding status...');
  final prefs = await SharedPreferences.getInstance();
  final status = prefs.getBool('has_completed_onboarding') ?? false;
  LogService.debug('RouteGuards: Onboarding status loaded: $status');
  return status;
});

/// Provider for authentication status
final authStatusProvider = FutureProvider<bool>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  return user != null && !user.isAnonymous;
});

/// Route guard service for handling redirects and access control
class RouteGuards {
  /// Handle route redirects based on app state
  static String? handleRedirect(BuildContext context, GoRouterState state) {
    LogService.debug('RouteGuards: Checking redirect for path: ${state.uri.path}');

    // Don't redirect if we're already on splash screen
    if (state.uri.path == '/splash') {
      LogService.debug('RouteGuards: On splash screen, no redirect needed');
      return null;
    }

    final container = ProviderScope.containerOf(context);

    // Check authentication status first
    final authStatus = container.read(authStatusProvider);
    if (authStatus.isLoading) {
      LogService.debug('RouteGuards: Auth status still loading, no redirect');
      return null;
    }
    if (authStatus.hasValue && authStatus.value!) {
      // If authenticated and on onboarding, go to home
      if (state.uri.path == AppRoutes.onboarding) {
        LogService.debug('RouteGuards: Authenticated, redirecting to home');
        return AppRoutes.home;
      }
      // If authenticated and not on onboarding, no redirect
      LogService.debug('RouteGuards: Authenticated, no redirect needed');
      return null;
    }

    // If not authenticated, check onboarding status
    final onboardingStatus = container.read(onboardingStatusProvider);
    LogService.debug(
      'RouteGuards: Onboarding status - loading: ${onboardingStatus.isLoading}, hasValue: ${onboardingStatus.hasValue}, value: ${onboardingStatus.valueOrNull}',
    );
    if (onboardingStatus.isLoading) {
      LogService.debug('RouteGuards: Onboarding status still loading, no redirect');
      return null;
    }
    if (onboardingStatus.hasValue && !onboardingStatus.value!) {
      if (state.uri.path != AppRoutes.onboarding) {
        LogService.debug('RouteGuards: Redirecting to onboarding');
        return AppRoutes.onboarding;
      }
    }
    if (onboardingStatus.hasValue &&
        onboardingStatus.value! &&
        state.uri.path == AppRoutes.onboarding) {
      LogService.debug('RouteGuards: Onboarding completed, redirecting to home');
      return AppRoutes.home;
    }

    // Check feature flags (future implementation)
    if (_isFeatureDisabled(state.uri.path)) {
      LogService.debug('RouteGuards: Feature disabled, redirecting to home');
      return AppRoutes.home;
    }

    LogService.debug('RouteGuards: No redirect needed');
    return null; // No redirect needed
  }

  /// Check if a feature is disabled
  static bool _isFeatureDisabled(String path) {
    // Future implementation for feature flags
    // For now, return false (all features enabled)
    return false;
  }

  /// Mark onboarding as completed
  static Future<void> markOnboardingCompleted() async {
    LogService.debug('RouteGuards: Marking onboarding as completed');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
    LogService.debug('RouteGuards: Onboarding marked as completed');
  }

  /// Check if user has completed onboarding
  static Future<bool> hasCompletedOnboarding() async {
    LogService.debug('RouteGuards: Checking if onboarding completed');
    final prefs = await SharedPreferences.getInstance();
    final status = prefs.getBool('has_completed_onboarding') ?? false;
    LogService.debug('RouteGuards: Onboarding completed status: $status');
    return status;
  }

  /// Reset onboarding status (for testing)
  static Future<void> resetOnboardingStatus() async {
    LogService.debug('RouteGuards: Resetting onboarding status');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('has_completed_onboarding');
    LogService.debug('RouteGuards: Onboarding status reset');
  }
}
