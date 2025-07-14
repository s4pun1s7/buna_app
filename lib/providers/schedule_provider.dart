import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/schedule_service.dart';
import '../models/schedule.dart';

final scheduleProvider = FutureProvider<List<ScheduleEntry>>((ref) async {
  final service = ScheduleService();
  return service.getFavoriteScheduleEntries();
});
