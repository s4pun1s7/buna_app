import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../navigation/route_guards.dart';
import '../navigation/app_router.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the onboarding status provider
    final onboardingStatus = ref.watch(onboardingStatusProvider);
    
    // Handle the async state
    return onboardingStatus.when(
      data: (hasCompletedOnboarding) {
        // Navigate based on onboarding status
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (hasCompletedOnboarding) {
            AppRouter.goToHome(context);
          } else {
            AppRouter.goToOnboarding(context);
          }
        });
        
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading Buna Festival...'),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading Buna Festival...'),
            ],
          ),
        ),
      ),
      error: (error, stackTrace) {
        // On error, default to onboarding
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppRouter.goToOnboarding(context);
        });
        
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('Error loading app'),
                SizedBox(height: 8),
                Text('Redirecting to onboarding...'),
              ],
            ),
          ),
        );
      },
    );
  }
} 