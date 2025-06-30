import '../features/venues/venues_data.dart';
import '../models/favorites_manager.dart';
import '../models/schedule.dart';

/// Service to encapsulate all schedule and favorites filtering/sorting logic.
class ScheduleService {
  final FavoritesManager favMgr;
  ScheduleService({FavoritesManager? favoritesManager})
    : favMgr = favoritesManager ?? FavoritesManager();

  /// Returns all events as schedule entries, sorted by date/time.
  List<ScheduleEntry> getAllEventsSorted() {
    final List<ScheduleEntry> all = [
      for (final venue in venues)
        for (final event in venue.events)
          ScheduleEntry(venue: venue, event: event),
    ];
    all.sort(_compareEntries);
    return all;
  }

  /// Returns only favorite events as schedule entries, sorted by date/time.
  List<ScheduleEntry> getFavoriteScheduleEntries() {
    final List<ScheduleEntry> favEntries = [
      for (final venue in venues)
        for (final event in venue.events)
          if (favMgr.isEventFavorite(venue, event))
            ScheduleEntry(venue: venue, event: event),
    ];
    favEntries.sort(_compareEntries);
    return favEntries;
  }

  /// Returns all events, but favorite events are listed first.
  List<ScheduleEntry> getFavoriteEventsFirst() {
    final favKeys = favMgr.favoriteEvents
        .map(
          (e) => favMgr.eventKey(
            venues.firstWhere((v) => v.events.contains(e)),
            e,
          ),
        )
        .toSet();
    final all = getAllEventsSorted();
    all.sort((a, b) {
      final aFav = favKeys.contains(favMgr.eventKey(a.venue, a.event));
      final bFav = favKeys.contains(favMgr.eventKey(b.venue, b.event));
      if (aFav && !bFav) return -1;
      if (!aFav && bFav) return 1;
      return 0;
    });
    return all;
  }

  int _compareEntries(ScheduleEntry a, ScheduleEntry b) {
    final dateA = DateTime.tryParse(a.event.date) ?? DateTime(2100);
    final dateB = DateTime.tryParse(b.event.date) ?? DateTime(2100);
    final timeA = a.event.time.split(' - ').first;
    final timeB = b.event.time.split(' - ').first;
    final dtA = DateTime(
      dateA.year,
      dateA.month,
      dateA.day,
      int.tryParse(timeA.split(':')[0]) ?? 0,
      int.tryParse(timeA.split(':')[1]) ?? 0,
    );
    final dtB = DateTime(
      dateB.year,
      dateB.month,
      dateB.day,
      int.tryParse(timeB.split(':')[0]) ?? 0,
      int.tryParse(timeB.split(':')[1]) ?? 0,
    );
    return dtA.compareTo(dtB);
  }
}
