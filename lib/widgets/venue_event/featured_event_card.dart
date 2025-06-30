import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Example Event model (replace with your real model)
class Event {
  final String name;
  final String venue;
  final String date;
  final String time;
  const Event({required this.name, required this.venue, required this.date, required this.time});
}

// Controller State
class FeaturedEventState {
  final bool isFavorite;
  final bool isRSVPed;
  final bool isLoading;
  FeaturedEventState({this.isFavorite = false, this.isRSVPed = false, this.isLoading = false});
  FeaturedEventState copyWith({bool? isFavorite, bool? isRSVPed, bool? isLoading}) =>
      FeaturedEventState(
        isFavorite: isFavorite ?? this.isFavorite,
        isRSVPed: isRSVPed ?? this.isRSVPed,
        isLoading: isLoading ?? this.isLoading,
      );
}

// Controller
class FeaturedEventController extends StateNotifier<FeaturedEventState> {
  FeaturedEventController() : super(FeaturedEventState());

  void toggleFavorite() {
    state = state.copyWith(isFavorite: !state.isFavorite);
    // Optionally: call analytics, update backend, etc.
  }

  Future<void> rsvp() async {
    state = state.copyWith(isLoading: true);
    // Simulate network call
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false, isRSVPed: true);
    // Optionally: notify other widgets/providers
  }
}

final featuredEventControllerProvider =
    StateNotifierProvider<FeaturedEventController, FeaturedEventState>(
        (ref) => FeaturedEventController());

class FeaturedEventCard extends ConsumerWidget {
  final Event event;
  const FeaturedEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(featuredEventControllerProvider);
    final controller = ref.read(featuredEventControllerProvider.notifier);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(event.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              subtitle: Text('${event.venue} • ${event.date} ${event.time}'),
              trailing: IconButton(
                icon: Icon(state.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.pink),
                onPressed: controller.toggleFavorite,
                tooltip: state.isFavorite ? 'Unfavorite' : 'Favorite',
              ),
            ),
            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (state.isRSVPed)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("You are RSVP'd!", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              )
            else
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: controller.rsvp,
                  child: const Text('RSVP'),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 