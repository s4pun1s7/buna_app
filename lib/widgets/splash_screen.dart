import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../navigation/route_guards.dart';
import '../navigation/app_router.dart';
import 'buna_logo.dart';

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
        
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BunaLogoWithText(
                  logoSize: 120,
                  textSize: 32,
                  showSubtitle: true,
                ),
                const SizedBox(height: 32),
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Loading...',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const BunaLogoWithText(
                logoSize: 120,
                textSize: 32,
                showSubtitle: true,
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
      error: (error, stackTrace) {
        // On error, default to onboarding
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppRouter.goToOnboarding(context);
        });
        
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BunaLogoWithText(
                  logoSize: 120,
                  textSize: 32,
                  showSubtitle: true,
                ),
                const SizedBox(height: 32),
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading app',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Redirecting to onboarding...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 