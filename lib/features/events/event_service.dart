import '../../models/event.dart';

abstract class EventDataSource {
  Future<List<Event>> fetchEvents();
}

class LocalEventDataSource implements EventDataSource {
  @override
  Future<List<Event>> fetchEvents() async {
    // Sample local events
    return [
      Event(
        id: '1',
        name: 'Opening Ceremony',
        description: 'Kickoff event for the festival.',
        date: DateTime(2025, 7, 25, 18, 0),
        venueId: 'v1',
      ),
      Event(
        id: '2',
        name: 'Art Workshop',
        description: 'Hands-on workshop with local artists.',
        date: DateTime(2025, 7, 26, 14, 0),
        venueId: 'v2',
      ),
    ];
  }
}
