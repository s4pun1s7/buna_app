import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'route_constants.dart';

/// Provider for onboarding status
final onboardingStatusProvider = FutureProvider<bool>((ref) async {
  debugPrint('RouteGuards: Loading onboarding status...');
  final prefs = await SharedPreferences.getInstance();
  final status = prefs.getBool('has_completed_onboarding') ?? false;
  debugPrint('RouteGuards: Onboarding status loaded: $status');
  return status;
});

/// Provider for authentication status
final authStatusProvider = FutureProvider<bool>((ref) async {
  // For now, return true since we're using anonymous auth
  // In the future, this would check Firebase Auth status
  return true;
});

/// Route guard service for handling redirects and access control
class RouteGuards {
  /// Handle route redirects based on app state
  static String? handleRedirect(BuildContext context, GoRouterState state) {
    debugPrint('RouteGuards: Checking redirect for path: ${state.uri.path}');
    
    // Don't redirect if we're already on splash screen
    if (state.uri.path == '/splash') {
      debugPrint('RouteGuards: On splash screen, no redirect needed');
      return null;
    }
    
    final container = ProviderScope.containerOf(context);
    
    // Check onboarding status
    final onboardingStatus = container.read(onboardingStatusProvider);
    debugPrint('RouteGuards: Onboarding status - loading: ${onboardingStatus.isLoading}, hasValue: ${onboardingStatus.hasValue}, value: ${onboardingStatus.valueOrNull}');
    
    // If onboarding status is still loading, don't redirect yet
    if (onboardingStatus.isLoading) {
      debugPrint('RouteGuards: Onboarding status still loading, no redirect');
      return null;
    }
    
    // If onboarding is not completed and we're not on onboarding page, redirect
    if (onboardingStatus.hasValue && !onboardingStatus.value!) {
      if (state.uri.path != AppRoutes.onboarding) {
        debugPrint('RouteGuards: Redirecting to onboarding');
        return AppRoutes.onboarding;
      }
    }
    
    // If onboarding is completed and we're on onboarding page, redirect to home
    if (onboardingStatus.hasValue && onboardingStatus.value! && state.uri.path == AppRoutes.onboarding) {
      debugPrint('RouteGuards: Onboarding completed, redirecting to home');
      return AppRoutes.home;
    }
    
    // Check authentication status
    final authStatus = container.read(authStatusProvider);
    
    // If auth status is still loading, don't redirect yet
    if (authStatus.isLoading) {
      debugPrint('RouteGuards: Auth status still loading, no redirect');
      return null;
    }
    
    if (authStatus.hasValue && !authStatus.value!) {
      if (AppRoutes.requiresAuth(state.uri.path)) {
        debugPrint('RouteGuards: Redirecting to onboarding due to auth');
        return AppRoutes.onboarding; // or login route
      }
    }
    
    // Check feature flags (future implementation)
    if (_isFeatureDisabled(state.uri.path)) {
      debugPrint('RouteGuards: Feature disabled, redirecting to home');
      return AppRoutes.home;
    }
    
    debugPrint('RouteGuards: No redirect needed');
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
    debugPrint('RouteGuards: Marking onboarding as completed');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
    debugPrint('RouteGuards: Onboarding marked as completed');
  }
  
  /// Check if user has completed onboarding
  static Future<bool> hasCompletedOnboarding() async {
    debugPrint('RouteGuards: Checking if onboarding completed');
    final prefs = await SharedPreferences.getInstance();
    final status = prefs.getBool('has_completed_onboarding') ?? false;
    debugPrint('RouteGuards: Onboarding completed status: $status');
    return status;
  }
  
  /// Reset onboarding status (for testing)
  static Future<void> resetOnboardingStatus() async {
    debugPrint('RouteGuards: Resetting onboarding status');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('has_completed_onboarding');
    debugPrint('RouteGuards: Onboarding status reset');
  }
} 