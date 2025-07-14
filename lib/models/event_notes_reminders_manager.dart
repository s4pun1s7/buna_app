import 'package:shared_preferences/shared_preferences.dart';
import '../features/venues/venues_data.dart';

class EventNotesRemindersManager {
  static final EventNotesRemindersManager _instance =
      EventNotesRemindersManager._internal();
  factory EventNotesRemindersManager() => _instance;
  EventNotesRemindersManager._internal();

  final Set<String> _reminders = {};

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _reminders.clear();
    _reminders.addAll((prefs.getStringList('event_reminders') ?? []));
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('event_reminders', _reminders.toList());
  }

  String eventKey(Venue venue, Event event) =>
      '${venue.name}|${event.name}|${event.date}|${event.time}';

  bool hasReminder(Venue venue, Event event) =>
      _reminders.contains(eventKey(venue, event));
  void toggleReminder(Venue venue, Event event) {
    final key = eventKey(venue, event);
    if (_reminders.contains(key)) {
      _reminders.remove(key);
    } else {
      _reminders.add(key);
    }
    save();
  }
}
