import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:buna_app/providers/festival_data_provider.dart';
import 'package:buna_app/widgets/error_screen.dart';
import 'package:buna_app/widgets/loading_indicator.dart';
import 'package:buna_app/services/error_handler.dart';
import 'package:buna_app/features/venues/venues_data.dart';
import 'package:buna_app/navigation/app_router.dart';
import 'package:buna_app/theme/app_theme.dart';

class MapsScreen extends ConsumerStatefulWidget {
  const MapsScreen({super.key});

  @override
  ConsumerState<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends ConsumerState<MapsScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  Position? _userPosition;
  bool _isLoadingLocation = false;
  String _searchQuery = '';
  Venue? _selectedVenue;

  @override
  void initState() {
    super.initState();
    _loadVenues();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() => _isLoadingLocation = true);
    
    try {
      // Check permissions
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

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _userPosition = position;
        _addUserLocationMarker();
      });
    } catch (e) {
      // Handle location errors silently
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _addUserLocationMarker() {
    if (_userPosition != null) {
      _circles.add(
        Circle(
          circleId: const CircleId('user_location'),
          center: LatLng(_userPosition!.latitude, _userPosition!.longitude),
          radius: 100, // 100 meters radius
          fillColor: AppTheme.primaryColor.withValues(alpha: 0.2),
          strokeColor: AppTheme.primaryColor,
          strokeWidth: 2,
        ),
      );
    }
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
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    _getMarkerColor(venue),
                  ),
                  infoWindow: InfoWindow(
                    title: venue.name,
                    snippet: venue.address,
                    onTap: () => _showVenueDetails(venue),
                  ),
                  onTap: () => _onMarkerTapped(venue),
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

  double _getMarkerColor(Venue venue) {
    // Use different colors based on venue type or number of events
    final eventCount = venue.events.length;
    if (eventCount > 5) return BitmapDescriptor.hueRed; // Many events
    if (eventCount > 2) return BitmapDescriptor.hueOrange; // Some events
    return BitmapDescriptor.hueGreen; // Few events
  }

  void _onMarkerTapped(Venue venue) {
    setState(() => _selectedVenue = venue);
    _animateToVenue(venue);
  }

  void _animateToVenue(Venue venue) {
    if (_mapController != null && venue.latitude != null && venue.longitude != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(venue.latitude!, venue.longitude!),
          16,
        ),
      );
    }
  }

  void _showVenueDetails(Venue venue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _VenueDetailsSheet(venue: venue),
    );
  }

  void _centerOnUserLocation() {
    if (_userPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_userPosition!.latitude, _userPosition!.longitude),
          15,
        ),
      );
    }
  }

  List<Venue> _getFilteredVenues(List<Venue> venues) {
    if (_searchQuery.isEmpty) return venues;
    return venues.where((venue) =>
      venue.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      venue.address.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final venuesAsync = ref.watch(venuesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Venues Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(venuesProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: venuesAsync.when(
        data: (venues) {
          if (venues.isEmpty) {
            return _buildEmptyState();
          }

          final filteredVenues = _getFilteredVenues(venues);
          final initialCameraPosition = _calculateInitialCameraPosition(venues);

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: _markers,
                circles: _circles,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
              
              // Search bar
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: _buildSearchBar(),
              ),
              
              // User location button
              Positioned(
                bottom: 200,
                right: 16,
                child: _buildUserLocationButton(),
              ),
              
              // Venue list bottom sheet
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _VenueListSheet(
                  venues: filteredVenues,
                  onVenueTap: _onMarkerTapped,
                  selectedVenue: _selectedVenue,
                ),
              ),
            ],
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

  Widget _buildSearchBar() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search venues...',
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () => setState(() => _searchQuery = ''),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserLocationButton() {
    return FloatingActionButton(
      heroTag: 'user_location',
      mini: true,
      backgroundColor: Colors.white,
      foregroundColor: AppTheme.primaryColor,
      onPressed: _isLoadingLocation ? null : _centerOnUserLocation,
      child: _isLoadingLocation
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.my_location),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 64,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No venues available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for venue updates',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  CameraPosition _calculateInitialCameraPosition(List<Venue> venues) {
    double? minLat, maxLat, minLng, maxLng;
    for (final venue in venues) {
      if (venue.latitude != null && venue.longitude != null) {
        minLat = minLat == null ? venue.latitude! : min(minLat, venue.latitude!);
        maxLat = maxLat == null ? venue.latitude! : max(maxLat, venue.latitude!);
        minLng = minLng == null ? venue.longitude! : min(minLng, venue.longitude!);
        maxLng = maxLng == null ? venue.longitude! : max(maxLng, venue.longitude!);
      }
    }

    if (minLat != null && maxLat != null && minLng != null && maxLng != null) {
      return CameraPosition(
        target: LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2),
        zoom: 12,
      );
    }

    return const CameraPosition(
      target: LatLng(43.2141, 27.9147), // Varna coordinates
      zoom: 12,
    );
  }
}

class _VenueListSheet extends StatelessWidget {
  final List<Venue> venues;
  final Function(Venue) onVenueTap;
  final Venue? selectedVenue;

  const _VenueListSheet({
    required this.venues,
    required this.onVenueTap,
    this.selectedVenue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Venues (${venues.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Tap to view on map',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // Venue list
          Expanded(
            child: venues.isEmpty
                ? Center(
                    child: Text(
                      'No venues found',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: venues.length,
                    itemBuilder: (context, index) {
                      final venue = venues[index];
                      final isSelected = selectedVenue?.id == venue.id;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: isSelected ? 4 : 1,
                        color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : null,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getVenueColor(venue).withValues(alpha: 0.2),
                            child: Icon(
                              Icons.location_on,
                              color: _getVenueColor(venue),
                              size: 20,
                            ),
                          ),
                          title: Text(
                            venue.name,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            '${venue.address} • ${venue.events.length} events',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => onVenueTap(venue),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getVenueColor(Venue venue) {
    final eventCount = venue.events.length;
    if (eventCount > 5) return Colors.red;
    if (eventCount > 2) return Colors.orange;
    return Colors.green;
  }
}

class _VenueDetailsSheet extends StatelessWidget {
  final Venue venue;

  const _VenueDetailsSheet({required this.venue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Venue name
          Text(
            venue.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Address
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  venue.address,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Events count
          Row(
            children: [
              Icon(Icons.event, color: AppTheme.primaryColor, size: 16),
              const SizedBox(width: 4),
              Text(
                '${venue.events.length} events',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.directions),
                  label: const Text('Directions'),
                  onPressed: () {
                    Navigator.pop(context);
                    _openDirections(venue);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.info),
                  label: const Text('View Details'),
                  onPressed: () {
                    Navigator.pop(context);
                    AppRouter.goToVenues(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openDirections(Venue venue) {
    if (venue.latitude != null && venue.longitude != null) {
      final url = 'https://www.google.com/maps/dir/?api=1&destination=${venue.latitude},${venue.longitude}';
      // You can use url_launcher here to open directions
    }
  }
}

// TODO: When google_maps_flutter_web supports AdvancedMarkerElement, migrate marker code to use it for web compatibility and future-proofing.
// See: https://developers.google.com/maps/documentation/javascript/reference/advanced-markers
