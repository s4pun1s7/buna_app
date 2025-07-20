import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/venues/venues_data.dart' as venues_data;

class FeaturedVenueCard extends ConsumerWidget {
  final venues_data.Venue venue;
  final VoidCallback? onDetails; // Should use AppRoutes.venueDetailsRoute(venue.id).go(context)

  const FeaturedVenueCard({super.key, required this.venue, this.onDetails});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              venue.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              venue.address,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            if (venue.events.isNotEmpty) ...[
              Text(
                'Upcoming Events:',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              ...venue.events
                  .take(2)
                  .map(
                    (event) => Text(
                      '\u2022 ${event.name} (${event.date} ${event.time})',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onDetails,
                icon: const Icon(Icons.info_outline),
                label: const Text('More Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
