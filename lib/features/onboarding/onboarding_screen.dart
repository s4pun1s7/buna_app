import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _pageIndex = 0;
  String _selectedLanguage = 'en';
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
    setState(() {
      _selectedLanguage = lang;
      // TODO: Set app locale globally
    });
  }

  @override
  Widget build(BuildContext context) {
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
              _titles[_pageIndex],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(_descriptions[_pageIndex], textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _next,
              child: Text(_pageIndex == _titles.length - 1 ? 'Done' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }
}
