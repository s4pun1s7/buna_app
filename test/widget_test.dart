// This is a basic Flutter widget test for the Buna Festival App.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buna_app/models/artist.dart';
import 'package:buna_app/widgets/featured/featured_artist_card.dart';
import 'package:buna_app/widgets/featured/featured_venue_card.dart';
import 'package:buna_app/widgets/featured/next_event_card.dart';
import 'package:buna_app/features/venues/venues_data.dart';
import 'package:buna_app/models/schedule.dart';
import 'package:buna_app/main.dart';

void main() {
  testWidgets('Buna app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BunaAppWithPermissions());

    // Verify that the app loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('FeaturedArtistCard displays artist info and details button', (
    WidgetTester tester,
  ) async {
    final artist = Artist(
      id: '1',
      name: 'Test Artist',
      country: 'Testland',
      bio: 'A test artist bio.',
      specialty: 'Test Art',
      imageUrl: null,
      website: '', // Provide empty string instead of null
      socialMedia: const [],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: FeaturedArtistCard(artist: artist, onDetails: () {}),
      ),
    );
    expect(find.text('Test Artist'), findsOneWidget);
    expect(find.text('Test Art'), findsOneWidget);
    expect(find.text('A test artist bio.'), findsOneWidget);
    expect(find.text('More Details'), findsOneWidget);
  });

  testWidgets('FeaturedVenueCard displays venue info and details button', (
    WidgetTester tester,
  ) async {
    final venue = Venue(
      name: 'Test Venue',
      address: '123 Test St',
      latitude: null,
      longitude: null,
      events: [],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: FeaturedVenueCard(venue: venue, onDetails: () {}),
      ),
    );
    expect(find.text('Test Venue'), findsOneWidget);
    expect(find.text('123 Test St'), findsOneWidget);
    expect(find.text('More Details'), findsOneWidget);
  });

  testWidgets(
    'NextEventCard displays event and venue info and details button',
    (WidgetTester tester) async {
      final venue = Venue(
        name: 'Event Venue',
        address: '456 Event Ave',
        latitude: null,
        longitude: null,
        events: [],
      );
      final event = Event(
        name: 'Test Event',
        date: '2024-05-30',
        time: '18:00 - 20:00',
      );
      final entry = ScheduleEntry(venue: venue, event: event);
      await tester.pumpWidget(
        MaterialApp(
          home: NextEventCard(entry: entry, onDetails: () {}),
        ),
      );
      expect(find.text('Test Event'), findsOneWidget);
      expect(find.text('2024-05-30 • 18:00 - 20:00'), findsOneWidget);
      expect(find.text('Venue: Event Venue'), findsOneWidget);
      expect(find.text('Event Details'), findsOneWidget);
    },
  );
}
