import '../../services/artist_data_service.dart';
import '../../models/artist.dart';

class LocalArtistDataSource implements ArtistDataSource {
  @override
  Future<List<Artist>> fetchArtists() async {
    // Add 4 new unique artists and the sample artist from ArtistDataService
    return [
      Artist(
        id: 'artist_002',
        name: 'Lina Müller',
        country: 'Germany',
        bio:
            'Lina is a multimedia artist exploring the intersection of sound and sculpture. Her installations have been exhibited across Europe.',
        specialty: 'Sound Art, Sculpture',
        imageUrl: 'https://example.com/artists/lina_mueller.jpg',
        website: 'https://linamueller.art',
        socialMedia: ['https://instagram.com/lina.mueller'],
      ),
      Artist(
        id: 'artist_003',
        name: 'Carlos Rivera',
        country: 'Mexico',
        bio:
            'Carlos is a muralist and street artist whose vibrant works bring color and life to urban spaces.',
        specialty: 'Mural, Street Art',
        imageUrl: 'https://example.com/artists/carlos_rivera.jpg',
        website: 'https://carlosrivera.mx',
        socialMedia: ['https://twitter.com/carlosrivera'],
      ),
      Artist(
        id: 'artist_004',
        name: 'Amina El-Sayed',
        country: 'Egypt',
        bio:
            'Amina is a contemporary painter whose abstract works are inspired by the landscapes and culture of North Africa.',
        specialty: 'Painting, Abstract',
        imageUrl: 'https://example.com/artists/amina_elsayed.jpg',
        website: 'https://aminaelsayed.com',
        socialMedia: ['https://facebook.com/amina.elsayed'],
      ),
      Artist(
        id: 'artist_005',
        name: 'Sophie Dubois',
        country: 'France',
        bio:
            'Sophie is a performance artist and choreographer known for her innovative site-specific dance pieces.',
        specialty: 'Performance, Dance',
        imageUrl: 'https://example.com/artists/sophie_dubois.jpg',
        website: 'https://sophiedubois.fr',
        socialMedia: ['https://instagram.com/sophie.dubois'],
      ),
      ...ArtistDataService.getArtists(),
    ];
  }
}

/// ArtistDataSource interface for fetching artists.
///
/// Implement this class to provide artist data from your preferred source.
abstract class ArtistDataSource {
  Future<List<Artist>> fetchArtists();
}
