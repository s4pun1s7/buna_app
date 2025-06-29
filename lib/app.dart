import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:buna_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/venues/venues_screen.dart';
import 'features/maps/maps_screen.dart';
import 'features/news/news_screen.dart';
import 'features/info/info_screen.dart';
import 'package:buna_app/theme/app_theme.dart';
import 'widgets/buna_nav_bar.dart';
import 'models/favorites_manager.dart';
import '../features/venues/venues_data.dart';
import '../models/schedule.dart';
import '../../models/event_notes_reminders_manager.dart';
import 'widgets/language_toggle.dart';
import 'services/schedule_service.dart'; // Importing ScheduleService
import 'widgets/schedule_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/favorites_provider.dart';
import 'providers/schedule_provider.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _pages = [
    _AnonymousHome(),
    VenuesScreen(),
    MapsScreen(),
    NewsScreen(),
    InfoScreen(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text('Buna Festival Home')),
          body: _pages[_selectedIndex],
          bottomNavigationBar: BunaNavBar(
            currentIndex: _selectedIndex,
            onTap: _onNavTap,
          ),
        ),
        // Place the language toggle above the nav bar, not overlapping it
        SafeArea(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 32), // was 72, now 32 to bring closer
              child: LanguageToggle(
                currentLocale: Localizations.localeOf(context),
                onLocaleChanged: (locale) {
                  final appState = context.findAncestorStateOfType<_BunaAppState>();
                  appState?.setLocale(locale);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AnonymousHome extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AnonymousHome> createState() => _AnonymousHomeState();
}

class _AnonymousHomeState extends ConsumerState<_AnonymousHome> {
  bool _showFullSchedule = false;

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final schedule = ref.watch(scheduleProvider);
    final favVenues = favorites.favoriteVenues;
    final favEvents = [
      for (final venue in venues)
        for (final event in venue.events)
          if (favorites.isEventFavorite(venue, event)) {'venue': venue, 'event': event}
    ];
    final hasSchedule = schedule.isNotEmpty;
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
              onPressed: () => GoRouter.of(context).push('/info'),
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () => GoRouter.of(context).push('/info'),
            ),
          ],
        ),
        const SizedBox(height: 32),
        if (hasSchedule)
          ScheduleCard(
            schedule: _showFullSchedule ? schedule : schedule.take(3).toList(),
            expanded: _showFullSchedule,
            onExpand: schedule.length > 3 && !_showFullSchedule
                ? () => setState(() => _showFullSchedule = true)
                : null,
            onCollapse: _showFullSchedule && schedule.length > 3
                ? () => setState(() => _showFullSchedule = false)
                : null,
            showExpandButton: schedule.length > 3 && !_showFullSchedule,
            showCollapseButton: _showFullSchedule && schedule.length > 3,
            title: 'Your Schedule',
          ),
        const SizedBox(height: 32),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.redAccent.shade200, size: 28),
                    const SizedBox(width: 8),
                    Text('Your Favorites', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                const Divider(height: 24),
                Text('Venues', style: Theme.of(context).textTheme.titleMedium),
                favVenues.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('No favorite venues yet.'),
                      )
                    : Column(
                        children: favVenues
                            .map((v) => ListTile(
                                  leading: const Icon(Icons.location_on, color: Colors.blueAccent),
                                  title: Text(v.name),
                                  subtitle: Text(v.address, maxLines: 1, overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                      ),
                const SizedBox(height: 20),
                Text('Events', style: Theme.of(context).textTheme.titleMedium),
                favEvents.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('No favorite events yet.'),
                      )
                    : Column(
                        children: favEvents
                            .map((e) {
                              final venue = e['venue'] as Venue?;
                              final event = e['event'] as Event?;
                              final notesMgr = EventNotesRemindersManager();
                              final hasReminder = (venue != null && event != null) ? notesMgr.hasReminder(venue, event) : false;
                              final note = (venue != null && event != null) ? notesMgr.getNote(venue, event) : null;
                              return ListTile(
                                leading: const Icon(Icons.star, color: Colors.orange),
                                title: Text(event?.name ?? ''),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 14, color: Colors.blueGrey),
                                        const SizedBox(width: 2),
                                        Flexible(child: Text(venue?.name ?? '')),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today, size: 14, color: Colors.teal),
                                        const SizedBox(width: 2),
                                        Text(event?.date ?? ''),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.access_time, size: 14, color: Colors.indigo),
                                        const SizedBox(width: 2),
                                        Text(event?.time ?? ''),
                                      ],
                                    ),
                                    if (note != null && note.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.note, size: 14, color: Colors.amber),
                                            const SizedBox(width: 4),
                                            Expanded(child: Text(note, style: const TextStyle(fontStyle: FontStyle.italic))),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        hasReminder ? Icons.alarm_on : Icons.alarm_add,
                                        color: hasReminder ? Colors.green : Colors.grey,
                                      ),
                                      tooltip: hasReminder ? 'Remove reminder' : 'Add reminder',
                                      onPressed: (venue != null && event != null)
                                          ? () {
                                              notesMgr.toggleReminder(venue, event);
                                            }
                                          : null,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit_note, color: Colors.amber),
                                      tooltip: 'Add/Edit note',
                                      onPressed: (venue != null && event != null)
                                          ? () async {
                                              final controller = TextEditingController(text: notesMgr.getNote(venue, event));
                                              final result = await showDialog<String>(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text('Add/Edit Note'),
                                                  content: TextField(
                                                    controller: controller,
                                                    maxLines: 3,
                                                    decoration: const InputDecoration(hintText: 'Enter your note...'),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(ctx),
                                                      child: const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(ctx, controller.text),
                                                      child: const Text('Save'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (result != null) {
                                                notesMgr.setNote(venue, event, result);
                                              }
                                            }
                                          : null,
                                    ),
                                  ],
                                ),
                              );
                            })
                            .toList(),
                      ),
              ],
            ),
          ),
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
