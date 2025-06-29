import 'package:flutter/material.dart';
import '../models/schedule.dart';

class ScheduleCard extends StatelessWidget {
  final List<ScheduleEntry> schedule;
  final bool expanded;
  final VoidCallback? onExpand;
  final VoidCallback? onCollapse;
  final bool showExpandButton;
  final bool showCollapseButton;
  final String title;

  const ScheduleCard({
    super.key,
    required this.schedule,
    this.expanded = false,
    this.onExpand,
    this.onCollapse,
    this.showExpandButton = false,
    this.showCollapseButton = false,
    this.title = 'Your Schedule',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.schedule, color: Colors.deepPurple, size: 28),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(height: 24),
            ...schedule.map((entry) => ListTile(
                  leading: Icon(
                    Icons.event,
                    color: Colors.deepPurple,
                  ),
                  title: Text(entry.event.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.blueGrey),
                          const SizedBox(width: 2),
                          Flexible(child: Text(entry.venue.name)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Colors.teal),
                          const SizedBox(width: 2),
                          Text(entry.event.date),
                          const SizedBox(width: 8),
                          const Icon(Icons.access_time, size: 14, color: Colors.indigo),
                          const SizedBox(width: 2),
                          Text(entry.event.time),
                        ],
                      ),
                    ],
                  ),
                )),
            if (showExpandButton)
              TextButton(
                onPressed: onExpand,
                child: const Text('See full schedule'),
              ),
            if (showCollapseButton)
              TextButton(
                onPressed: onCollapse,
                child: const Text('Show less'),
              ),
          ],
        ),
      ),
    );
  }
}
