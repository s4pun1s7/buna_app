import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:buna_app/widgets/onboarding_step.dart';
import 'package:buna_app/providers/locale_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _pageIndex = 0;
  final List<String> _titles = [
    'Welcome to Buna Festival',
    'Discover Art & Events',
    'Personalize Your Experience',
  ];
  final List<String> _descriptions = [
    'Explore the festival, artists, and venues.',
    'Find art pieces, events, and more on the map.',
    'Bookmark favorites, set reminders, and get news.',
  ];

  void _next() {
    if (_pageIndex < _titles.length - 1) {
      setState(() => _pageIndex++);
    } else {
      context.go('/home');
    }
  }

  void _skip() => context.go('/home');

  void _selectLanguage(String lang) {
    final locale = lang == 'en' ? const Locale('en') : const Locale('bg');
    ref.read(localeProvider.notifier).setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final selectedLanguage = currentLocale.languageCode;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding'),
        actions: [
          if (_pageIndex < _titles.length - 1)
            TextButton(onPressed: _skip, child: const Text('Skip')),
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
                  selected: selectedLanguage == 'en',
                  onSelected: (_) => _selectLanguage('en'),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('Български'),
                  selected: selectedLanguage == 'bg',
                  onSelected: (_) => _selectLanguage('bg'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            OnboardingStep(
              title: _titles[_pageIndex],
              description: _descriptions[_pageIndex],
              onNext: _next,
              isLast: _pageIndex == _titles.length - 1,
            ),
          ],
        ),
      ),
    );
  }
}
