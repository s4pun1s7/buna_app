import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/locale_provider.dart';
import '../../navigation/route_guards.dart';
import '../../navigation/route_constants.dart';
import '../../services/auth_service.dart';
import 'package:buna_app/widgets/loading_indicator.dart';
import 'package:buna_app/widgets/error_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String _selectedLanguage = 'en';
  bool _isLoading = false;
  String? _authError;
  final AuthService _authService = AuthService();

  void _getStarted() async {
    if (_isLoading) return; // Prevent multiple calls
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      debugPrint('Onboarding: Starting get started process...');
      
      // Mark onboarding as completed
      await RouteGuards.markOnboardingCompleted();
      debugPrint('Onboarding: Marked as completed');
      
      // Set the selected language
      final localeNotifier = ref.read(localeProvider.notifier);
      localeNotifier.setLocale(Locale(_selectedLanguage));
      debugPrint('Onboarding: Set locale to $_selectedLanguage');
      
      // Invalidate the onboarding status provider to trigger a refresh
      ref.invalidate(onboardingStatusProvider);
      debugPrint('Onboarding: Invalidated onboarding status provider');
      
      // Navigate to home
      if (mounted) {
        debugPrint('Onboarding: Navigating to home...');
        context.go(AppRoutes.home);
      }
    } catch (e) {
      debugPrint('Onboarding: Error during get started: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() { _isLoading = true; _authError = null; });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AnimatedLoadingDialog(message: 'Signing in...'),
    );
    try {
      await _authService.signInWithGoogle();
      if (mounted) Navigator.of(context).pop();
      _getStarted();
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      setState(() { _isLoading = false; _authError = 'Google sign-in failed. Please try again.'; });
      showDialog(
        context: context,
        builder: (_) => AnimatedErrorDialog(
          title: 'Sign-In Error',
          message: _authError!,
          onCancel: () => Navigator.of(context).pop(),
          onRetry: () {
            Navigator.of(context).pop();
            _signInWithGoogle();
          },
        ),
      );
    }
  }

  Future<void> _signInAsGuest() async {
    setState(() { _isLoading = true; _authError = null; });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AnimatedLoadingDialog(message: 'Signing in...'),
    );
    try {
      await _authService.signInAnonymously();
      if (mounted) Navigator.of(context).pop();
      _getStarted();
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      setState(() { _isLoading = false; _authError = 'Guest sign-in failed. Please try again.'; });
      showDialog(
        context: context,
        builder: (_) => AnimatedErrorDialog(
          title: 'Sign-In Error',
          message: _authError!,
          onCancel: () => Navigator.of(context).pop(),
          onRetry: () {
            Navigator.of(context).pop();
            _signInAsGuest();
          },
        ),
      );
    }
  }

  void _selectLanguage(String lang) {
    setState(() {
      _selectedLanguage = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _getStarted, 
            child: _isLoading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Skip')
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Language selection at the top, centered
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('English'),
                  selected: _selectedLanguage == 'en',
                  onSelected: (_) => _selectLanguage('en'),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('Български'),
                  selected: _selectedLanguage == 'bg',
                  onSelected: (_) => _selectLanguage('bg'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Welcome to Buna Festival',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text(
              'Explore the festival, artists, and venues. Find art pieces, events, and more on the map. Bookmark favorites, set reminders, and get news.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: Image.asset('assets/Buna pink.png', width: 24, height: 24, cacheWidth: 48),
              label: const Text('Continue with Google'),
              onPressed: _isLoading ? null : _signInWithGoogle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(48),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _isLoading ? null : _signInAsGuest,
              child: const Text('Continue as Guest'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _getStarted,
              child: _isLoading 
                ? const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Loading...'),
                    ],
                  )
                : const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
