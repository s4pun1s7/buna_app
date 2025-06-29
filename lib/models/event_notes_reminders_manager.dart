import 'package:shared_preferences/shared_preferences.dart';
import '../features/venues/venues_data.dart';

class EventNotesRemindersManager {
  static final EventNotesRemindersManager _instance = EventNotesRemindersManager._internal();
  factory EventNotesRemindersManager() => _instance;
  EventNotesRemindersManager._internal();

  final Map<String, String> _notes = {};
  final Set<String> _reminders = {};

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _notes.clear();
    _reminders.clear();
    final notesString = prefs.getString('event_notes') ?? '{}';
    final Map<String, dynamic> notesMap = notesString.isNotEmpty ? Map<String, dynamic>.from(await Future.value(notesString.isNotEmpty ? (notesString.startsWith('{') ? (notesString.endsWith('}') ? (notesString.length > 2 ? Map<String, dynamic>.from(Uri.splitQueryString(notesString.substring(1, notesString.length - 1).replaceAll(', ', '&').replaceAll(': ', '='))) : {}) : {}) : {}) : {})) : {};
    _notes.addAll(notesMap.map((k, v) => MapEntry(k, v.toString())));
    _reminders.addAll((prefs.getStringList('event_reminders') ?? []));
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('event_notes', _notes.toString());
    await prefs.setStringList('event_reminders', _reminders.toList());
  }

  String eventKey(Venue venue, Event event) => '${venue.name}|${event.name}|${event.date}|${event.time}';

  String? getNote(Venue venue, Event event) => _notes[eventKey(venue, event)];
  void setNote(Venue venue, Event event, String note) {
    _notes[eventKey(venue, event)] = note;
    save();
  }

  bool hasReminder(Venue venue, Event event) => _reminders.contains(eventKey(venue, event));
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
