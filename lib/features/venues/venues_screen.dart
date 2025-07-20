import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/favorites_provider.dart';
import 'package:buna_app/widgets/common/index.dart';
import 'venues_data.dart';
import '../../widgets/navigation/buna_app_bar.dart';
import '../../providers/user_provider.dart';

class VenuesScreen extends ConsumerStatefulWidget {
  const VenuesScreen({super.key});

  @override
  ConsumerState<VenuesScreen> createState() => _VenuesScreenState();
}

class _VenuesScreenState extends ConsumerState<VenuesScreen> {
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = _simulateLoad();
  }

  Future<void> _simulateLoad({bool throwError = false}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (throwError) throw Exception('Failed to load venues.');
  }

  void _openVenueOnMap(Venue venue) {
    if (venue.latitude != null && venue.longitude != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: const BunaAppBar(title: ''),
            body: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(venue.latitude!, venue.longitude!),
                zoom: 16,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(venue.name),
                  position: LatLng(venue.latitude!, venue.longitude!),
                  infoWindow: InfoWindow(
                    title: venue.name,
                    snippet: venue.address,
                  ),
                ),
              },
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    final favorites = ref.watch(favoritesProvider);
    final userAsync = ref.watch(userProvider);
    final isAnonymous = userAsync.value != null && userAsync.value!.isAnonymous;
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return AppErrorWidget(
            message: 'Failed to load venues.',
            onRetry: () {
              setState(() {
                _future = _simulateLoad();
              });
            },
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: venues.length,
          separatorBuilder: (context, i) => const SizedBox(height: 16),
          itemBuilder: (context, i) {
            final venue = venues[i];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        venue.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.place,
                            size: 18,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(child: Text(venue.address)),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.blueAccent,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              favorites.isVenueFavorite(venue)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.redAccent,
                            ),
                            tooltip: isAnonymous
                                ? 'Login required to save favorites'
                                : (favorites.isVenueFavorite(venue)
                                      ? 'Remove from favorites'
                                      : 'Add to favorites'),
                            onPressed: isAnonymous
                                ? () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please log in to save favorites.',
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                : () {
                                    favorites.toggleVenueFavorite(venue);
                                  },
                          ),
                          if (venue.latitude != null && venue.longitude != null)
                            IconButton(
                              icon: const Icon(Icons.map, color: Colors.green),
                              tooltip: 'View on Map',
                              onPressed: () => _openVenueOnMap(venue),
                            ),
                        ],
                      ),
                    ),
                    if (venue.events.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          bottom: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.event,
                                  size: 18,
                                  color: Colors.deepPurple,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Events:',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ...venue.events.map(
                              (e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        favorites.isEventFavorite(venue, e)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.orange,
                                        size: 20,
                                      ),
                                      tooltip: isAnonymous
                                          ? 'Login required to save favorites'
                                          : (favorites.isEventFavorite(venue, e)
                                                ? 'Remove event from favorites'
                                                : 'Add event to favorites'),
                                      onPressed: isAnonymous
                                          ? () {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Please log in to save favorites.',
                                                  ),
                                                  duration: Duration(
                                                    seconds: 2,
                                                  ),
                                                ),
                                              );
                                            }
                                          : () {
                                              favorites.toggleEventFavorite(
                                                venue,
                                                e,
                                              );
                                            },
                                    ),
                                    const SizedBox(width: 2),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.name,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 14,
                                                color: Colors.teal,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                e.date,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                              const SizedBox(width: 12),
                                              const Icon(
                                                Icons.access_time,
                                                size: 14,
                                                color: Colors.indigo,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                e.time,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
