// Centralized mock/demo data for development and testing

import '../models/artist.dart';
import '../features/map_gallery/map_gallery_screen.dart';

class MockData {
  static const List<String> qrCodes = [
    'buna://event/opening-ceremony',
    'buna://venue/main-square',
    'buna://artist/elena-rodriguez',
    'buna://workshop/digital-art',
    'buna://reward/free-coffee',
  ];

  static final List<Artist> artists = [
    Artist(
      id: '1',
      name: 'Elena Rodriguez',
      country: 'Spain',
      bio: 'Elena Rodriguez is a renowned light artist known for her large-scale environmental installations that transform urban spaces into magical landscapes. Her work explores the relationship between light, space, and human perception.',
      specialty: 'Light Art & Environmental Installations',
      imageUrl: null,
      website: 'https://elenarodriguez.com',
      socialMedia: ['@elenarodriguez', '@elenalightart'],
    ),
    // Add more mock artists as needed
  ];

  static final List<MapGalleryItem> mapGalleryItems = [
    MapGalleryItem(
      id: '1',
      title: 'Main Square',
      description: 'The heart of Varna and the primary venue for major festival events. Features the iconic light installation "Urban Dreams" by Elena Rodriguez.',
      category: 'Venue',
      date: DateTime.now().subtract(const Duration(days: 1)),
      location: 'Central Square, Varna',
      tags: ['main venue', 'light art', 'ceremonies'],
      isInteractive: true,
    ),
    // ... (add more items as in the original mock data)
  ];

  // Add AR experiences, map gallery items, social posts, etc.
} 