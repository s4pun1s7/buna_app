import 'package:flutter/material.dart';
import '../models/festival_data.dart';

/// Card widget for displaying festival events in the schedule
class ScheduleCard extends StatelessWidget {
  final FestivalEvent event;
  final VoidCallback? onTap;

  const ScheduleCard({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScaleFactorOf(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (event.startTime != null)
                          Text(
                            'Time: ${event.startTime}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(event.category),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event.category ?? 'Event',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12 * scale,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (event.venue != null)
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.venue!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              Text(
                event.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    if (category == null) return Colors.grey;
    
    switch (category.toLowerCase()) {
      case 'music':
        return Colors.orange;
      case 'art':
      case 'exhibition':
        return Colors.purple;
      case 'performance':
        return Colors.pink;
      case 'workshop':
        return Colors.blue;
      case 'ceremony':
        return Colors.amber;
      case 'digital art':
        return Colors.cyan;
      case 'environmental art':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
