import 'package:flutter/material.dart';

import '../../models/artist.dart';
// import '../config/assets.dart'; // Removing unused import

/// A reusable card widget for displaying artist information.
class ArtistCard extends StatelessWidget {
  final Artist artist;
  final VoidCallback? onTap;
  final bool expanded;
  final VoidCallback? onExpandToggle;

  const ArtistCard({
    Key? key,
    required this.artist,
    this.onTap,
    this.expanded = false,
    this.onExpandToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List of local asset images for random selection
    final List<String> localImages = [
      'assets/images/buna_black.png',
      'assets/images/buna_blue.png',
      'assets/images/buna_pink.png',
      'assets/images/8.jpeg',
      'assets/images/BUNA3_BlueStory_600x600.webp',
      'assets/images/BUNA3_PinkStory_600x600.webp',
    ];
    // Use a seeded random for consistency per artist
    final int seed = artist.name.hashCode;
    final String randomAsset = localImages[seed.abs() % localImages.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.08),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'artist_avatar_${artist.name}',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.18),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.3),
                            width: 2.5,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.12),
                              Colors.white,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.grey.shade100,
                          backgroundImage: artist.imageUrl != null
                              ? NetworkImage(artist.imageUrl!)
                              : AssetImage(randomAsset) as ImageProvider,
                          child: artist.imageUrl == null ? null : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            artist.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                artist.country,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            artist.specialty,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (onExpandToggle != null)
                      IconButton(
                        icon: Icon(
                          expanded ? Icons.expand_less : Icons.expand_more,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: onExpandToggle,
                      ),
                  ],
                ),
                if (expanded)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 4,
                      right: 4,
                      bottom: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (artist.bio.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  size: 18,
                                  color: Colors.deepPurple,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    artist.bio,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (artist.website.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.link,
                                  size: 18,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () {}, // Dummy link
                                    child: Text(
                                      artist.website,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (artist.socialMedia.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Wrap(
                              spacing: 8,
                              children: artist.socialMedia
                                  .map(
                                    (url) => GestureDetector(
                                      onTap: () {}, // Dummy link
                                      child: Chip(
                                        label: Text(
                                          url,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        backgroundColor: Colors.blue.shade50,
                                        avatar: const Icon(
                                          Icons.alternate_email,
                                          size: 16,
                                          color: Colors.blueAccent,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
