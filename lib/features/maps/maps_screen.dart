import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:buna_app/providers/festival_data_provider.dart';
import 'package:buna_app/widgets/error_screen.dart';
import 'package:buna_app/widgets/loading_indicator.dart';
import 'package:buna_app/services/error_handler.dart';

class MapsScreen extends ConsumerStatefulWidget {
  const MapsScreen({super.key});

  @override
  ConsumerState<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends ConsumerState<MapsScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  Future<void> _loadVenues() async {
    final venuesAsync = ref.read(venuesProvider);
    await venuesAsync.when(
      data: (venues) {
        setState(() {
          _markers.clear();
          for (final venue in venues) {
            if (venue.latitude != null && venue.longitude != null) {
              _markers.add(
                Marker(
                  markerId: MarkerId(venue.id.toString()),
                  position: LatLng(venue.latitude!, venue.longitude!),
                  infoWindow: InfoWindow(
                    title: venue.name,
                    snippet: venue.address,
                  ),
                ),
              );
            }
          }
        });
      },
      loading: () {},
      error: (error, stackTrace) {
        // Error handling is done by the provider
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final venuesAsync = ref.watch(venuesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Venues Map')),
      body: venuesAsync.when(
        data: (venues) {
          if (venues.isEmpty) {
            return const Center(
              child: Text('No venues available'),
            );
          }

          // Calculate bounds for all venues
          double? minLat, maxLat, minLng, maxLng;
          for (final venue in venues) {
            if (venue.latitude != null && venue.longitude != null) {
              minLat = minLat == null ? venue.latitude! : min(minLat, venue.latitude!);
              maxLat = maxLat == null ? venue.latitude! : max(maxLat, venue.latitude!);
              minLng = minLng == null ? venue.longitude! : min(minLng, venue.longitude!);
              maxLng = maxLng == null ? venue.longitude! : max(maxLng, venue.longitude!);
            }
          }

          final initialCameraPosition = minLat != null && maxLat != null && minLng != null && maxLng != null
              ? CameraPosition(
                  target: LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2),
                  zoom: 12,
                )
              : const CameraPosition(
                  target: LatLng(43.2141, 27.9147), // Varna coordinates
                  zoom: 12,
                );

          return GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stackTrace) {
          final appError = error is AppException ? error : AppException(
            'Failed to load venues',
            code: 'MAPS_ERROR',
            originalError: error,
            stackTrace: stackTrace,
          );
          return ErrorScreen(
            error: appError,
            onRetry: () => ref.refresh(venuesProvider),
          );
        },
      ),
    );
  }
}

// TODO: When google_maps_flutter_web supports AdvancedMarkerElement, migrate marker code to use it for web compatibility and future-proofing.
// See: https://developers.google.com/maps/documentation/javascript/reference/advanced-markers
