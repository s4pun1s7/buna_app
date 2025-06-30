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
  String _statusMessage = '';
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
    if (_isLoading) return;
    setState(() { _isLoading = true; _authError = null; _statusMessage = 'Starting Google sign-in...'; });
    try {
      _showStatusBanner('Opening Google sign-in dialog...');
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AnimatedLoadingDialog(message: 'Signing in...'),
      );
      _showStatusBanner('Waiting for Google authentication...');
      await _authService.signInWithGoogle();
      _showStatusBanner('Google sign-in successful!');
      if (mounted) Navigator.of(context).pop();
      // Mark onboarding as completed after successful Google sign-in
      await RouteGuards.markOnboardingCompleted();
      _hideStatusBanner();
      _getStarted();
    } catch (e) {
      if (mounted) {
        Navigator.of(context).maybePop();
        setState(() {
          _isLoading = false;
          _authError = 'Google sign-in failed. Please try again.';
          _statusMessage = 'Google sign-in failed.';
        });
        _showStatusBanner('Google sign-in failed.');
        showDialog(
          context: context,
          builder: (_) => AnimatedErrorDialog(
            title: 'Sign-In Error',
            message: _authError!,
            onCancel: () {
              Navigator.of(context).pop();
              _hideStatusBanner();
            },
            onRetry: () {
              Navigator.of(context).pop();
              _hideStatusBanner();
              _signInWithGoogle();
            },
          ),
        );
      }
    }
  }

  void _showStatusBanner(String message) {
    _statusMessage = message;
    if (mounted) {
      ScaffoldMessenger.of(context).clearMaterialBanners();
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text(message),
          backgroundColor: Colors.blue.shade50,
          actions: [
            TextButton(
              onPressed: () => _hideStatusBanner(),
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
    }
  }

  void _hideStatusBanner() {
    if (mounted) {
      ScaffoldMessenger.of(context).clearMaterialBanners();
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
            // Placeholder for future login option 1
            OutlinedButton(
              onPressed: null, // TODO: Implement login option 1
              child: const Text('Login Option 1 (Coming Soon)'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for future login option 2
            OutlinedButton(
              onPressed: null, // TODO: Implement login option 2
              child: const Text('Login Option 2 (Coming Soon)'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : () async {
                if (_isLoading) return;
                setState(() { _isLoading = true; _authError = null; });
                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const AnimatedLoadingDialog(message: 'Signing in...'),
                  );
                  await _authService.signInAnonymously();
                  if (mounted) Navigator.of(context).pop();
                  _getStarted();
                } catch (e) {
                  if (mounted) {
                    Navigator.of(context).maybePop();
                    setState(() { _isLoading = false; _authError = 'Anonymous sign-in failed. Please try again.'; });
                    showDialog(
                      context: context,
                      builder: (_) => AnimatedErrorDialog(
                        title: 'Sign-In Error',
                        message: _authError!,
                        onCancel: () => Navigator.of(context).pop(),
                        onRetry: () {
                          Navigator.of(context).pop();
                          // Retry anonymous sign-in
                        },
                      ),
                    );
                  }
                }
              },
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
