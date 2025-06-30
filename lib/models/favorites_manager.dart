import 'package:flutter/foundation.dart';
import '../features/venues/venues_data.dart';

class FavoritesManager extends ChangeNotifier {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  final Set<String> _favoriteVenueNames = {};
  final Set<String> _favoriteEventKeys = {};

  bool isVenueFavorite(Venue venue) => _favoriteVenueNames.contains(venue.name);
  void toggleVenueFavorite(Venue venue) {
    if (!isVenueFavorite(venue)) {
      _favoriteVenueNames.add(venue.name);
    } else {
      _favoriteVenueNames.remove(venue.name);
    }
    notifyListeners();
  }

  bool isEventFavorite(Venue venue, Event event) =>
      _favoriteEventKeys.contains(eventKey(venue, event));
  void toggleEventFavorite(Venue venue, Event event) {
    final key = eventKey(venue, event);
    if (!_favoriteEventKeys.contains(key)) {
      _favoriteEventKeys.add(key);
    } else {
      _favoriteEventKeys.remove(key);
    }
    notifyListeners();
  }

  String eventKey(Venue venue, Event event) =>
      '${venue.name}|${event.name}|${event.date}|${event.time}';

  List<Venue> get favoriteVenues => venues.where(isVenueFavorite).toList();
  List<Event> get favoriteEvents => [
    for (final venue in venues)
      for (final event in venue.events)
        if (isEventFavorite(venue, event)) event,
  ];
}
