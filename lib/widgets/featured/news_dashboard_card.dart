import 'package:flutter/material.dart';
import '../../models/festival_data.dart' as fest_data;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class NewsDashboardCard extends StatelessWidget {
  final fest_data.NewsArticle article;
  final VoidCallback? onDetails;

  const NewsDashboardCard({super.key, required this.article, this.onDetails});

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
              child: article.featuredImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: article.featuredImageUrl!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 72,
                        height: 72,
                        color: Colors.grey[200],
                        child: const Icon(Icons.article, size: 40),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 72,
                        height: 72,
                        color: Colors.grey[200],
                        child: const Icon(Icons.article, size: 40),
                      ),
                    )
                  : Container(
                      width: 72,
                      height: 72,
                      color: Colors.grey[200],
                      child: const Icon(Icons.article, size: 40),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy').format(article.date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.excerpt,
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
                      label: const Text('Read More'),
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
