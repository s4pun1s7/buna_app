import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/artist.dart';
import '../../models/schedule.dart';
import '../../models/festival_data.dart';
import '../../features/venues/venues_data.dart' as venues_data;

/// Home screen with feature flag integration
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artist = ref.watch(featuredArtistProvider);
    final venue = ref.watch(featuredVenueProvider);
    final event = ref.watch(nextEventProvider);
    final news = ref.watch(featuredNewsProvider);

    final ScrollController scrollController = ScrollController();
    final ValueNotifier<double> offsetNotifier = ValueNotifier<double>(0);

    return Scaffold(
      appBar: AppBar(title: const Text('Buna Festival Dashboard')),
      body: Stack(
        children: [
          // Parallax background image
          ValueListenableBuilder<double>(
            valueListenable: offsetNotifier,
            builder: (context, offset, child) {
              return Transform.translate(
                offset: Offset(0, offset * 0.4), // Parallax factor
                child: SizedBox(
                  width: double.infinity,
                  height: 350,
                  child: Image.asset(
                    'assets/buna_pink.png', // Replace with your preferred asset
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                offsetNotifier.value = scrollController.offset;
              }
              return false;
            },
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.only(
                top: 200,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Festival logo and branding
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.festival,
                          size: 100,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        Text(
                          'BUNA',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (artist != null) ...[
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Featured Artist: ${artist.name}'),
                        subtitle: Text(artist.specialty),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          /* navigate to artist */
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (venue != null) ...[
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text('Featured Venue: ${venue.name}'),
                        subtitle: Text(venue.address),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          /* navigate to venue */
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (event != null) ...[
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.event),
                        title: Text('Next Event: ${event.event.name}'),
                        subtitle: Text('${event.event.date} • ${event.event.time}'),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          /* navigate to event */
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (news != null) ...[
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.article),
                        title: Text('Latest News: ${news.title}'),
                        subtitle: Text(news.excerpt),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          /* navigate to news */
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Mock providers for demonstration. Replace with real API providers as needed.
final artistsProvider = Provider<List<Artist>>(
  (ref) => [
    Artist(
      id: '1',
      name: 'Elena Rodriguez',
      country: 'Spain',
      bio: 'Renowned light artist known for large-scale installations.',
      specialty: 'Light Art',
      imageUrl: null,
      website: 'https://elenarodriguez.com',
      socialMedia: ['@elenarodriguez'],
    ),
  ],
);
final featuredArtistProvider = Provider<Artist?>((ref) {
  final artists = ref.watch(artistsProvider);
  return artists.isNotEmpty ? artists.first : null;
});

final venuesProvider = Provider<List<venues_data.Venue>>(
  (ref) => venues_data.venues,
);
final featuredVenueProvider = Provider<venues_data.Venue?>((ref) {
  final venues = ref.watch(venuesProvider);
  return venues.isNotEmpty ? venues.first : null;
});
final scheduleProvider = Provider<List<ScheduleEntry>>((ref) {
  final venues = ref.watch(venuesProvider);
  final entries = <ScheduleEntry>[];
  for (final venue in venues) {
    for (final event in venue.events) {
      entries.add(ScheduleEntry(venue: venue, event: event));
    }
  }
  entries.sort((a, b) => a.event.date.compareTo(b.event.date));
  return entries;
});
final nextEventProvider = Provider<ScheduleEntry?>((ref) {
  final schedule = ref.watch(scheduleProvider);
  return schedule.isNotEmpty ? schedule.first : null;
});

final newsProvider = Provider<List<NewsArticle>>(
  (ref) => [
    NewsArticle(
      id: 1,
      title: 'Festival Opening',
      content: 'Join us for the grand opening!',
      excerpt: 'Grand opening event',
      date: DateTime.now(),
      featuredImageUrl: null,
      author: 'Team',
      categories: ['General'],
      url: 'https://bunavarna.com/opening',
    ),
  ],
);
final featuredNewsProvider = Provider<NewsArticle?>((ref) {
  final news = ref.watch(newsProvider);
  return news.isNotEmpty ? news.first : null;
});
