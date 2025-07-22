import '../models/artist.dart';

/// Sample artist data for Buna Festival
class ArtistDataService {
  static List<Artist> getArtists() {
    return [
      Artist(
        id: 'artist_001',
        name: 'Hiroshi Tanaka',
        country: 'Japan',
        bio:
            'Hiroshi Tanaka is a renowned digital artist known for blending traditional Japanese aesthetics with cutting-edge technology. His immersive installations and VR experiences have been featured in major festivals worldwide.',
        specialty: 'Digital Art, VR',
        imageUrl: 'https://example.com/artists/hiroshi_tanaka.jpg',
        website: 'https://hiroshitanaka.com',
        socialMedia: [
          'https://instagram.com/hiroshi.tanaka',
          'https://twitter.com/hiroshi_tanaka',
        ],
      ),
      // Add more artists as needed
    ];
  }
}
