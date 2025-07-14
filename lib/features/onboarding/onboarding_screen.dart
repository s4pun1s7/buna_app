import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/locale_provider.dart';
import '../../navigation/route_guards.dart';
import '../../navigation/route_constants.dart';
import '../../services/auth_service.dart';
import '../../widgets/common/index.dart';
import 'dart:math';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  String _selectedLanguage = 'en';
  bool _isLoading = false;
  String? _authError;
  String _statusMessage = '';
  final AuthService _authService = AuthService();

  late final AnimationController _logoController;
  late final Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );
    _logoController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

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
      body: Stack(
        children: [
          const AnimatedBackground(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
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
                ScaleTransition(
                  scale: _logoScale,
                  child: Image.asset(
                    'assets/buna_blue.png',
                    width: 110,
                    height: 110,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 16),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    'Welcome to Buna Festival',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 16),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 700),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 16),
                        child: child,
                      ),
                    );
                  },
                  child: const Text(
                    'Explore the festival, artists, and venues. Find art pieces, events, and more on the map. Bookmark favorites, set reminders, and get news.',
                    textAlign: TextAlign.center,
                  ),
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
        ],
      ),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  Colors.pink.shade50,
                  Colors.purple.shade50,
                  _controller.value,
                )!,
                Color.lerp(
                  Colors.blue.shade50,
                  Colors.pink.shade100,
                  1 - _controller.value,
                )!,
              ],
            ),
          ),
        );
      },
    );
  }
}
