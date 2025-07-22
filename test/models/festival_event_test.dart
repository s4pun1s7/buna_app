import 'package:flutter_test/flutter_test.dart';
import 'package:buna_app/models/festival_data.dart';

void main() {
  group('FestivalEvent', () {
    test('should serialize and deserialize correctly', () {
      final event = FestivalEvent(
        id: 1,
        title: 'Test Event',
        startDate: DateTime(2024, 6, 1),
        endDate: DateTime(2024, 6, 1),
        description: 'A test event',
        venue: 'Test Venue',
        url: '',
      );
      final json = event.toJson();
      final fromJson = FestivalEvent.fromJson(json);
      expect(fromJson.title, event.title);
      expect(fromJson.venue, event.venue);
      expect(fromJson.startDate, event.startDate);
    });
  });
} 