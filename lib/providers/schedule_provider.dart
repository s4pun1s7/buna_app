import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/schedule_service.dart';
import '../models/schedule.dart';

import 'favorites_provider.dart';

final scheduleProvider = FutureProvider<List<ScheduleEntry>>((ref) async {
  final favorites = ref.watch(favoritesProvider);
  final service = ScheduleService(favoritesManager: favorites);
  return service.getFavoriteScheduleEntries();
});
