import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:buna_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/venues/venues_screen.dart';
import 'features/maps/maps_screen.dart';
import 'features/news/news_screen.dart';
import 'features/info/info_screen.dart';
import 'package:buna_app/theme/app_theme.dart';

final _router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/venues', builder: (context, state) => const VenuesScreen()),
    GoRoute(path: '/maps', builder: (context, state) => const MapsScreen()),
    GoRoute(path: '/news', builder: (context, state) => const NewsScreen()),
    GoRoute(path: '/info', builder: (context, state) => const InfoScreen()),
  ],
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isAnonymous = user?.isAnonymous ?? true;
    return Scaffold(
      appBar: AppBar(title: const Text('Buna Festival Home')),
      body: isAnonymous ? _AnonymousHome() : _LoggedInHome(),
    );
  }
}

class _AnonymousHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Buna Festival', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text(
          'International decentralized festival supporting the Bulgarian contemporary visual scene, held in Varna.',
        ),
        const SizedBox(height: 8),
        const Text('Dates: Check the official website for the latest edition.'),
        const SizedBox(height: 16),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.facebook),
              onPressed: () =>
                  GoRouter.of(context).push('/info'), // Or launch URL
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () =>
                  GoRouter.of(context).push('/info'), // Or launch URL
            ),
          ],
        ),
      ],
    );
  }
}

class _LoggedInHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Welcome to Buna Festival!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.location_city),
          title: const Text('Venues & Favorites'),
          onTap: () => context.go('/venues'),
        ),
        ListTile(
          leading: const Icon(Icons.event),
          title: const Text('My Schedule'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.map),
          title: const Text('Map'),
          onTap: () => context.go('/maps'),
        ),
        ListTile(
          leading: const Icon(Icons.article),
          title: const Text('News'),
          onTap: () => context.go('/news'),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Info'),
          onTap: () => context.go('/info'),
        ),
      ],
    );
  }
}

class BunaApp extends StatefulWidget {
  const BunaApp({super.key});

  @override
  State<BunaApp> createState() => _BunaAppState();
}

class _BunaAppState extends State<BunaApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Buna Festival',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('bg')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
    );
  }
}
