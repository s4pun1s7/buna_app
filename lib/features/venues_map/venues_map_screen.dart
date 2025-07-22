import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:buna_app/features/venues/venues_data.dart';
import 'package:buna_app/providers/user_provider.dart';
import 'package:buna_app/providers/favorites_provider.dart';

class VenuesMapScreen extends ConsumerStatefulWidget {
  const VenuesMapScreen({super.key});

  @override
  ConsumerState<VenuesMapScreen> createState() => _VenuesMapScreenState();
}

class _VenuesMapScreenState extends ConsumerState<VenuesMapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  Position? _userPosition;

  @override
  void initState() {
    super.initState();
    _loadVenues();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() {});
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _userPosition = position;
        _addUserLocationMarker();
      });
    } finally {
      setState(() {});
    }
  }

  void _addUserLocationMarker() {
    if (_userPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(_userPosition!.latitude, _userPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
      );
    }
  }

  void _loadVenues() {
    _markers.clear();
    for (final venue in venues) {
      if (venue.latitude != null && venue.longitude != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(venue.name),
            position: LatLng(venue.latitude!, venue.longitude!),
            infoWindow: InfoWindow(
              title: venue.name,
              snippet: venue.address,
              onTap: () => _onVenueTap(venue),
            ),
            onTap: () => _onVenueTap(venue),
          ),
        );
      }
    }
  }

  void _onVenueTap(Venue venue) {
    setState(() {});
    if (_mapController != null &&
        venue.latitude != null &&
        venue.longitude != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(venue.latitude!, venue.longitude!),
          16,
        ),
      );
    }
  }

  CameraPosition _initialCameraPosition() {
    double? minLat, maxLat, minLng, maxLng;
    for (final venue in venues) {
      if (venue.latitude != null && venue.longitude != null) {
        minLat = minLat == null
            ? venue.latitude!
            : min(minLat, venue.latitude!);
        maxLat = maxLat == null
            ? venue.latitude!
            : max(maxLat, venue.latitude!);
        minLng = minLng == null
            ? venue.longitude!
            : min(minLng, venue.longitude!);
        maxLng = maxLng == null
            ? venue.longitude!
            : max(maxLng, venue.longitude!);
      }
    }
    if (minLat != null && maxLat != null && minLng != null && maxLng != null) {
      return CameraPosition(
        target: LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2),
        zoom: 12,
      );
    }
    return const CameraPosition(target: LatLng(43.2141, 27.9147), zoom: 12);
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final userAsync = ref.watch(userProvider);
    final isAnonymous = userAsync.value != null && userAsync.value!.isAnonymous;
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: _initialCameraPosition(),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (controller) => _mapController = controller,
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: venues.length,
            separatorBuilder: (context, i) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final venue = venues[i];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(venue.name),
                  subtitle: Text(venue.address),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.blueAccent,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      favorites.isVenueFavorite(venue)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.redAccent,
                    ),
                    tooltip: isAnonymous
                        ? 'Login required to save favorites'
                        : (favorites.isVenueFavorite(venue)
                              ? 'Remove from favorites'
                              : 'Add to favorites'),
                    onPressed: isAnonymous
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please log in to save favorites.',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        : () {
                            favorites.toggleVenueFavorite(venue);
                          },
                  ),
                  onTap: () => _onVenueTap(venue),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
