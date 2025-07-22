import '../../models/venue.dart';

abstract class VenueDataSource {
  Future<List<Venue>> fetchVenues();
}

class LocalVenueDataSource implements VenueDataSource {
  @override
  Future<List<Venue>> fetchVenues() async {
    // Sample local venues
    return [
      Venue(
        id: 'v1',
        name: 'Main Hall',
        address: '123 Festival Ave',
        city: 'Buna City',
        country: 'Japan',
      ),
      Venue(
        id: 'v2',
        name: 'Art Center',
        address: '456 Gallery Rd',
        city: 'Buna City',
        country: 'Japan',
      ),
    ];
  }
}
