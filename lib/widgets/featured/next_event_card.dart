import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../models/schedule.dart' as schedule_model;

class NextEventCard extends StatelessWidget {
  final schedule_model.ScheduleEntry entry;
  final VoidCallback? onDetails; // Should use AppRoutes.eventDetailsRoute(entry.event.id).go(context)

  const NextEventCard({super.key, required this.entry, this.onDetails});

  @override
  Widget build(BuildContext context) {
    try {
      final event = entry.event;
      final venue = entry.venue;
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${event.date} • ${event.time}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Venue: ${venue.name}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onDetails,
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Event Details'),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e, stack) {
      debugPrint('[NextEventCard] Error building card: ${e.toString()}');
      debugPrint('[NextEventCard] Stack: ${stack.toString()}');
      return Card(
        color: Colors.red[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 32),
              const SizedBox(height: 8),
              Text(
                'Error loading event card',
                style: TextStyle(color: Colors.red),
              ),
              Text(e.toString(), style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }
  }
}
