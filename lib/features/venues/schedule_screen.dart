import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buna_app/providers/schedule_provider.dart';
import 'package:buna_app/providers/favorites_provider.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedule = ref.watch(scheduleProvider);
    final favMgr = ref.watch(favoritesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Festival Schedule')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: schedule.length,
        separatorBuilder: (context, i) => const Divider(),
        itemBuilder: (context, i) {
          final entry = schedule[i];
          final isFav = favMgr.isEventFavorite(entry.venue, entry.event);
          return ListTile(
            leading: Icon(
              isFav ? Icons.star : Icons.event,
              color: isFav ? Colors.orange : Colors.deepPurple,
            ),
            title: Text(entry.event.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 2),
                    Flexible(child: Text(entry.venue.name)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.teal,
                    ),
                    const SizedBox(width: 2),
                    Text(entry.event.date),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.indigo,
                    ),
                    const SizedBox(width: 2),
                    Text(entry.event.time),
                  ],
                ),
              ],
            ),
            trailing: isFav
                ? const Icon(Icons.favorite, color: Colors.redAccent)
                : null,
          );
        },
      ),
    );
  }
}
