import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../navigation/route_guards.dart';
import '../navigation/app_router.dart';
import '../branding/index.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the userProvider for authentication state
    final userAsync = ref.watch(userProvider);

    // Web: handle Google sign-in redirect result
    if (identical(0, 0.0)) {
      // kIsWeb workaround for code edit
      return FutureBuilder(
        future: AuthService().getGoogleRedirectResult(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading(context);
          }
          if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppRouter.goToOnboarding(context);
            });
            return _buildError(context);
          }
          if (snapshot.hasData && snapshot.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppRouter.goToHome(context);
            });
            return _buildLoading(context);
          }
          // Fallback to normal userProvider logic
          return _buildUserProvider(context, ref, userAsync);
        },
      );
    }
    return _buildUserProvider(context, ref, userAsync);
  }

  Widget _buildUserProvider(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<User?> userAsync,
  ) {
    return userAsync.when(
      data: (user) {
        debugPrint(
          'SplashScreen: user = ' +
              (user?.uid ?? 'null') +
              ', isAnonymous = ${user?.isAnonymous}',
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (user != null && !user.isAnonymous) {
            AppRouter.goToHome(context);
          } else {
            AppRouter.goToOnboarding(context);
          }
        });
        return _buildLoading(context);
      },
      loading: () => _buildLoading(context),
      error: (error, stackTrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppRouter.goToOnboarding(context);
        });
        return _buildError(context);
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
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
            Text('Loading...', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
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
  }
}
