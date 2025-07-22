import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/artist_card.dart';
import '../../models/artist.dart';
import 'artist_service.dart';
import '../events/event_service.dart';
import '../venues/venue_service.dart';

/// Provider for the artist data source (local only)
final artistDataSourceProvider = Provider<ArtistDataSource>((ref) {
  return LocalArtistDataSource();
});

/// Provider for the event data source (local only)
final eventDataSourceProvider = Provider<EventDataSource>((ref) {
  return LocalEventDataSource();
});

/// Provider for the venue data source (local only)
final venueDataSourceProvider = Provider<VenueDataSource>((ref) {
  return LocalVenueDataSource();
});

/// Displays a searchable and filterable list of all participating artists.
///
/// Features search, country filter, and artist detail dialog.
class ArtistsScreen extends ConsumerStatefulWidget {
  const ArtistsScreen({super.key});

  @override
  ConsumerState<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends ConsumerState<ArtistsScreen> {
  @override
  Widget build(BuildContext context) {
    final artistDataSource = ref.watch(artistDataSourceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Artists')),
      body: FutureBuilder<List<Artist>>(
        future: artistDataSource.fetchArtists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: [39m${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No artists found.'));
          }
          final artists = snapshot.data!;
          return _ArtistList(artists: artists);
        },
      ),
    );
  }
}

// Reusable artist list widget using ArtistCard
class _ArtistList extends StatefulWidget {
  final List<Artist> artists;
  const _ArtistList({required this.artists});

  @override
  State<_ArtistList> createState() => _ArtistListState();
}

class _ArtistListState extends State<_ArtistList> {
  late List<bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = List.filled(widget.artists.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.artists.length,
      itemBuilder: (context, index) {
        final artist = widget.artists[index];
        return ArtistCard(
          artist: artist,
          expanded: _expanded[index],
          onExpandToggle: () {
            setState(() {
              _expanded[index] = !_expanded[index];
            });
          },
        );
      },
    );
  }
}
