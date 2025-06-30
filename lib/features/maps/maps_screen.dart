import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/error_screen.dart';
import '../venues/venues_data.dart';
import '../../widgets/venue_info_bottom_sheet.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late Future<void> _future;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _future = _simulateLoad();
  }

  Future<void> _simulateLoad({bool throwError = false}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (throwError) throw Exception('Failed to load map.');
  }

  void _onMarkerTap(Venue venue) {
    showModalBottomSheet(
      context: context,
      builder: (_) => VenueInfoBottomSheet(venue: venue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Festival Map')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorScreen(
              message: 'Failed to load map.',
              onRetry: () {
                setState(() {
                  _future = _simulateLoad();
                });
              },
            );
          }
          final markers = venues
              .where((v) => v.latitude != null && v.longitude != null)
              .map(
                (venue) => Marker(
                  markerId: MarkerId(venue.name),
                  position: LatLng(venue.latitude!, venue.longitude!),
                  infoWindow: InfoWindow(
                    title: venue.name,
                    snippet: venue.address,
                  ),
                  onTap: () => _onMarkerTap(venue),
                ),
              )
              .toSet();
          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(43.2141, 27.9147), // Varna, Bulgaria
              zoom: 13,
            ),
            markers: markers,
            onMapCreated: (controller) => _mapController = controller,
          );
        },
      ),
    );
  }
}

// TODO: When google_maps_flutter_web supports AdvancedMarkerElement, migrate marker code to use it for web compatibility and future-proofing.
// See: https://developers.google.com/maps/documentation/javascript/reference/advanced-markers
