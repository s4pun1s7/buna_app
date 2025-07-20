import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buna_app/models/favorites_manager.dart';
import 'package:buna_app/features/venues/venues_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('FavoritesManager', () {
    late FavoritesManager favoritesManager;
    final testVenue = Venue(
      name: 'Test Venue',
      address: '123 Test St',
      latitude: 0.0,
      longitude: 0.0,
      events: [],
    );
    final testEvent = Event(
      name: 'Test Event',
      date: '2024-06-01',
      time: '18:00 - 20:00',
    );

    setUp(() {
      favoritesManager = FavoritesManager();
    });

    test('should add and remove favorite venue', () async {
      expect(favoritesManager.isVenueFavorite(testVenue), isFalse);
      await favoritesManager.toggleVenueFavorite(testVenue);
      expect(favoritesManager.isVenueFavorite(testVenue), isTrue);
      await favoritesManager.toggleVenueFavorite(testVenue);
      expect(favoritesManager.isVenueFavorite(testVenue), isFalse);
    });

    test('should add and remove favorite event', () async {
      expect(favoritesManager.isEventFavorite(testVenue, testEvent), isFalse);
      await favoritesManager.toggleEventFavorite(testVenue, testEvent);
      expect(favoritesManager.isEventFavorite(testVenue, testEvent), isTrue);
      await favoritesManager.toggleEventFavorite(testVenue, testEvent);
      expect(favoritesManager.isEventFavorite(testVenue, testEvent), isFalse);
    });
  });
} 