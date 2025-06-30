import 'package:flutter/material.dart';
import '../features/venues/venues_data.dart';

class VenueInfoBottomSheet extends StatelessWidget {
  final Venue venue;
  const VenueInfoBottomSheet({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(venue.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.place, size: 18, color: Colors.blueGrey),
              const SizedBox(width: 4),
              Expanded(child: Text(venue.address)),
            ],
          ),
          if (venue.latitude != null && venue.longitude != null) ...[
            const SizedBox(height: 8),
            Text(
              'Lat: ${venue.latitude}, Lng: ${venue.longitude}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (venue.events.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.event, size: 18, color: Colors.deepPurple),
                const SizedBox(width: 6),
                Text('Events:', style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 4),
            ...venue.events.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.orange),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.name,
                            style: Theme.of(context).textTheme.bodyMedium,
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
                                style: Theme.of(context).textTheme.bodySmall,
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
                                style: Theme.of(context).textTheme.bodySmall,
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
        ],
      ),
    );
  }
}
