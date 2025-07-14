import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/artist.dart';

class FeaturedArtistCard extends StatelessWidget {
  final Artist artist;
  final VoidCallback? onDetails;

  const FeaturedArtistCard({super.key, required this.artist, this.onDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: artist.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: artist.imageUrl!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 72,
                        height: 72,
                        color: Colors.grey[200],
                        child: const Icon(Icons.person, size: 40),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 72,
                        height: 72,
                        color: Colors.grey[200],
                        child: const Icon(Icons.person, size: 40),
                      ),
                    )
                  : Container(
                      width: 72,
                      height: 72,
                      color: Colors.grey[200],
                      child: const Icon(Icons.person, size: 40),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artist.specialty,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    artist.bio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: onDetails,
                      icon: const Icon(Icons.info_outline),
                      label: const Text('More Details'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
