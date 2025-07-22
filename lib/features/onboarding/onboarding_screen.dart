import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/locale_provider.dart';
import '../../navigation/route_guards.dart';
import '../../navigation/route_constants.dart';
import '../../services/auth_service.dart';
// ...existing code...
import 'package:buna_app/l10n/app_localizations.dart';

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

  void _selectLanguage(String lang) async {
    setState(() {
      _selectedLanguage = lang;
    });
    final localeNotifier = ref.read(localeProvider.notifier);
    await localeNotifier.setLocale(Locale(lang));
  }

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _authError = null;
    });
    try {
      await _authService.signInWithGoogle();
      await _completeOnboarding();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _authError = 'Google sign-in failed. Please try again.';
      });
    }
  }

  Future<void> _signInAnonymously() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _authError = null;
    });
    try {
      await _authService.signInAnonymously();
      await _completeOnboarding();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _authError = 'Anonymous sign-in failed. Please try again.';
      });
    }
  }

  Future<void> _completeOnboarding() async {
    await RouteGuards.markOnboardingCompleted();
    ref.invalidate(onboardingStatusProvider);
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  Future<void> _signInWithEmail() async {
    // TODO: Implement email sign-in
    setState(() {
      _authError = 'Email sign-in not yet implemented.';
    });
  }

  Future<void> _signInWithApple() async {
    // TODO: Implement Apple sign-in
    setState(() {
      _authError = 'Apple sign-in not yet implemented.';
    });
  }

  Future<void> _signInWithFacebook() async {
    // TODO: Implement Facebook sign-in
    setState(() {
      _authError = 'Facebook sign-in not yet implemented.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF0052CC),
        child: Stack(
          children: [
            // Blue logo in the top left corner
            Positioned(
              top: 24,
              left: 24,
              child: Image.asset(
                'assets/images/buna_pink.png',
                width: 64,
                height: 64,
                fit: BoxFit.contain,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 48, left: 32, right: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.bunaVol3,
                      style: TextStyle(
                        color: Color(0xFFFF8EB4),
                        fontSize: 28,
                        fontFamily: 'RobotoMono',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      height: 2,
                      color: Color(0xFFFF8EB4),
                    ),
                    Text(
                      AppLocalizations.of(context)!.forumForContemporaryArt,
                      style: TextStyle(
                        color: Color(0xFFFF8EB4),
                        fontSize: 22,
                        fontFamily: 'RobotoMono',
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      height: 2,
                      color: Color(0xFFFF8EB4),
                    ),
                    Text(
                      AppLocalizations.of(context)!.festivalDates,
                      style: TextStyle(
                        color: Color(0xFFFF8EB4),
                        fontSize: 20,
                        fontFamily: 'RobotoMono',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Language toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ChoiceChip(
                          label: Text(AppLocalizations.of(context)!.english),
                          selected: _selectedLanguage == 'en',
                          onSelected: (_) => _selectLanguage('en'),
                          selectedColor: Color(0xFFFF8EB4),
                          labelStyle: TextStyle(
                            color: _selectedLanguage == 'en'
                                ? Color(0xFF0052CC)
                                : Color(0xFFFF8EB4),
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                        const SizedBox(width: 12),
                        ChoiceChip(
                          label: Text(AppLocalizations.of(context)!.bulgarian),
                          selected: _selectedLanguage == 'bg',
                          onSelected: (_) => _selectLanguage('bg'),
                          selectedColor: Color(0xFFFF8EB4),
                          labelStyle: TextStyle(
                            color: _selectedLanguage == 'bg'
                                ? Color(0xFF0052CC)
                                : Color(0xFFFF8EB4),
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Sign-in buttons (vertical, pretty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _signInWithGoogle,
                          icon: const Icon(Icons.login, size: 18),
                          label: Text(
                            AppLocalizations.of(context)!.signInGoogle,
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 40),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Color(0xFFFF8EB4),
                            foregroundColor: Color(0xFF0052CC),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _signInWithEmail,
                          icon: const Icon(Icons.email, size: 18),
                          label: const Text('Email'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 40),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Color(0xFFFF8EB4),
                            foregroundColor: Color(0xFF0052CC),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _signInWithApple,
                          icon: const Icon(Icons.apple, size: 18),
                          label: const Text('Apple'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 40),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Color(0xFFFF8EB4),
                            foregroundColor: Color(0xFF0052CC),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _signInWithFacebook,
                          icon: const Icon(Icons.facebook, size: 18),
                          label: const Text('Facebook'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 40),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Color(0xFFFF8EB4),
                            foregroundColor: Color(0xFF0052CC),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _signInAnonymously,
                          icon: const Icon(Icons.person_outline, size: 18),
                          label: _isLoading
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(AppLocalizations.of(context)!.loading),
                                  ],
                                )
                              : Text(AppLocalizations.of(context)!.signInGuest),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 40),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Color(0xFFFF8EB4),
                            foregroundColor: Color(0xFF0052CC),
                          ),
                        ),
                      ],
                    ),
                    if (_authError != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _authError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
