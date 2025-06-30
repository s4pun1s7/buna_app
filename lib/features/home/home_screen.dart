import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/feature_flags.dart';
import '../../navigation/app_router.dart';
import '../../widgets/buna_logo.dart';
import '../../widgets/featured_artist_card.dart';
import '../../widgets/featured_venue_card.dart';
import '../../widgets/next_event_card.dart';
import '../../widgets/news_dashboard_card.dart';
import '../artists/artists_screen.dart';
import '../venues/venues_data.dart';
import '../../models/schedule.dart';
import '../../models/festival_data.dart';

/// Home screen with feature flag integration
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artist = ref.watch(featuredArtistProvider);
    final venue = ref.watch(featuredVenueProvider);
    final event = ref.watch(nextEventProvider);
    final news = ref.watch(featuredNewsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buna Festival Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (artist != null) ...[
              FeaturedArtistCard(artist: artist, onDetails: () {/* navigate to artist */}),
              const SizedBox(height: 16),
            ],
            if (venue != null) ...[
              FeaturedVenueCard(venue: venue, onDetails: () {/* navigate to venue */}),
              const SizedBox(height: 16),
            ],
            if (event != null) ...[
              NextEventCard(entry: event, onDetails: () {/* navigate to event */}),
              const SizedBox(height: 16),
            ],
            if (news != null) ...[
              NewsDashboardCard(article: news, onDetails: () {/* navigate to news */}),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

// Mock providers for demonstration. Replace with real API providers as needed.
final artistsProvider = Provider<List<Artist>>((ref) => [
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
]);
final featuredArtistProvider = Provider<Artist?>((ref) {
  final artists = ref.watch(artistsProvider);
  return artists.isNotEmpty ? artists.first : null;
});

final venuesProvider = Provider<List<Venue>>((ref) => venues);
final featuredVenueProvider = Provider<Venue?>((ref) {
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

final newsProvider = Provider<List<NewsArticle>>((ref) => [
  NewsArticle(
    id: 1,
    title: 'Festival Opening Announced',
    content: 'The opening ceremony will feature spectacular light shows...',
    excerpt: 'The opening ceremony will feature spectacular light shows...',
    date: DateTime.now(),
    featuredImageUrl: null,
    author: 'Festival Team',
    categories: ['Announcement'],
    url: 'https://bunafestival.com/news/opening',
  ),
]);
final featuredNewsProvider = Provider<NewsArticle?>((ref) {
  final news = ref.watch(newsProvider);
  return news.isNotEmpty ? news.first : null;
}); 