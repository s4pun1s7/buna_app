import 'package:flutter/material.dart';
import '../../services/artist_data_service.dart';
import '../../models/artist.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;
  const ArtistCard({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (artist.imageUrl != null)
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(artist.imageUrl!),
                ),
              ),
            const SizedBox(height: 16),
            Text(artist.name, style: Theme.of(context).textTheme.titleLarge),
            Text(artist.country, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(
              artist.specialty,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(artist.bio),
            const SizedBox(height: 12),
            if (artist.website.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.link, size: 16),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      artist.website,
                      style: const TextStyle(color: Colors.blue),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            if (artist.socialMedia.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Wrap(
                  spacing: 8,
                  children: artist.socialMedia
                      .map((url) => Chip(label: Text(url)))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ArtistDemoScreen extends StatelessWidget {
  const ArtistDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final artist = ArtistDataService.getArtists().first;
    return Scaffold(
      appBar: AppBar(title: const Text('Sample Artist')),
      body: Center(child: ArtistCard(artist: artist)),
    );
  }
}
