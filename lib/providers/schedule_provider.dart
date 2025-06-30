import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/schedule_service.dart';
import '../models/schedule.dart';

final scheduleProvider = Provider<List<ScheduleEntry>>((ref) {
  final service = ScheduleService();
  return service.getFavoriteScheduleEntries();
});
