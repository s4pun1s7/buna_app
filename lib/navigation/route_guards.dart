import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'route_constants.dart';

/// Provider for onboarding status
final onboardingStatusProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('has_completed_onboarding') ?? false;
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
    final container = ProviderScope.containerOf(context);
    
    // Check onboarding status
    final onboardingStatus = container.read(onboardingStatusProvider);
    if (onboardingStatus.hasValue && !onboardingStatus.value!) {
      if (state.uri.path != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }
    }
    
    // Check authentication status
    final authStatus = container.read(authStatusProvider);
    if (authStatus.hasValue && !authStatus.value!) {
      if (AppRoutes.requiresAuth(state.uri.path)) {
        return AppRoutes.onboarding; // or login route
      }
    }
    
    // Check feature flags (future implementation)
    if (_isFeatureDisabled(state.uri.path)) {
      return AppRoutes.home;
    }
    
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
  }
  
  /// Check if user has completed onboarding
  static Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_completed_onboarding') ?? false;
  }
  
  /// Reset onboarding status (for testing)
  static Future<void> resetOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('has_completed_onboarding');
  }
} 