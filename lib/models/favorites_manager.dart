import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/venues/venues_data.dart';

class FavoritesManager extends ChangeNotifier {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal() {
    _loadFavorites();
  }

  final Set<String> _favoriteVenueNames = {};
  final Set<String> _favoriteEventKeys = {};

  static const String _venuesKey = 'favorite_venues';
  static const String _eventsKey = 'favorite_events';

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteVenueNames.clear();
    _favoriteVenueNames.addAll(prefs.getStringList(_venuesKey) ?? []);
    _favoriteEventKeys.clear();
    _favoriteEventKeys.addAll(prefs.getStringList(_eventsKey) ?? []);
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_venuesKey, _favoriteVenueNames.toList());
    await prefs.setStringList(_eventsKey, _favoriteEventKeys.toList());
  }

  bool isVenueFavorite(Venue venue) => _favoriteVenueNames.contains(venue.name);
  Future<void> toggleVenueFavorite(Venue venue) async {
    if (!isVenueFavorite(venue)) {
      _favoriteVenueNames.add(venue.name);
    } else {
      _favoriteVenueNames.remove(venue.name);
    }
    await _saveFavorites();
    notifyListeners();
  }

  bool isEventFavorite(Venue venue, Event event) =>
      _favoriteEventKeys.contains(eventKey(venue, event));
  Future<void> toggleEventFavorite(Venue venue, Event event) async {
    final key = eventKey(venue, event);
    if (!_favoriteEventKeys.contains(key)) {
      _favoriteEventKeys.add(key);
    } else {
      _favoriteEventKeys.remove(key);
    }
    await _saveFavorites();
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
