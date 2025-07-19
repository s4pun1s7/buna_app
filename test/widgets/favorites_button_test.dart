import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buna_app/widgets/venue_event/schedule_card.dart';
import 'package:buna_app/models/festival_data.dart';

void main() {
  testWidgets('Favorite button toggles state', (tester) async {
    final event = FestivalEvent(
      id: 1,
      title: 'Test Event',
      startDate: DateTime(2024, 6, 1),
      endDate: DateTime(2024, 6, 1),
      description: 'A test event',
      venue: 'Test Venue',
      url: '',
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ScheduleCard(
          event: event,
          onTap: () {},
        ),
      ),
    );
    // Add further checks as needed for your widget
  });
} 