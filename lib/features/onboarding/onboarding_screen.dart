import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/locale_provider.dart';
import '../../navigation/route_guards.dart';
import '../../navigation/route_constants.dart';
import '../../services/auth_service.dart';
import '../../widgets/common/index.dart';

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

  void _selectLanguage(String lang) {
    setState(() {
      _selectedLanguage = lang;
    });
    final localeNotifier = ref.read(localeProvider.notifier);
    localeNotifier.setLocale(Locale(lang));
  }

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _authError = null;
      _statusMessage = 'Starting Google sign-in...';
    });
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
      await _completeOnboarding();
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

  Future<void> _signInAnonymously() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _authError = null;
    });
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AnimatedLoadingDialog(message: 'Signing in...'),
      );
      await _authService.signInAnonymously();
      if (mounted) Navigator.of(context).pop();
      await _completeOnboarding();
    } catch (e) {
      if (mounted) {
        Navigator.of(context).maybePop();
        setState(() {
          _isLoading = false;
          _authError = 'Anonymous sign-in failed. Please try again.';
        });
        showDialog(
          context: context,
          builder: (_) => AnimatedErrorDialog(
            title: 'Sign-In Error',
            message: _authError!,
            onCancel: () => Navigator.of(context).pop(),
            onRetry: () {
              Navigator.of(context).pop();
              _signInAnonymously();
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
      final isDark = Theme.of(context).brightness == Brightness.dark;
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text(
            message,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: isDark
              ? const Color(0xFF333333)
              : const Color(0xFFD6ECFF),
          actions: [
            TextButton(
              onPressed: () => _hideStatusBanner(),
              child: const Text('Dismiss'),
              style: TextButton.styleFrom(
                foregroundColor: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      );
    }
  }

  void _hideStatusBanner() {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    }
  }

  Future<void> _completeOnboarding() async {
    await RouteGuards.markOnboardingCompleted();
    ref.invalidate(onboardingStatusProvider);
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            ElevatedButton(
              onPressed: _isLoading ? null : _signInWithGoogle,
              child: const Text('Continue with Google'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _signInAnonymously,
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
                  : const Text('Continue as Guest'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (_authError != null) ...[
              const SizedBox(height: 16),
              Text(_authError!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
