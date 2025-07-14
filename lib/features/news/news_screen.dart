import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../widgets/common/index.dart';
import 'package:buna_app/providers/festival_data_provider.dart';
import 'package:buna_app/models/festival_data.dart';
import 'package:buna_app/services/error_handler.dart';
import 'package:buna_app/utils/debouncer.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollDebouncer _scrollDebouncer = ScrollDebouncer();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollDebouncer.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Debounce scroll events to prevent excessive API calls
    _scrollDebouncer.call(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreNews();
      }
    });
  }

  Future<void> _loadMoreNews() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      await ref.read(newsStateProvider.notifier).loadMore(_currentPage + 1);
      setState(() {
        _currentPage++;
      });
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    final newsState = ref.watch(newsStateProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(newsStateProvider.notifier).refresh(),
      child: newsState.when(
        data: (news) => _buildNewsList(news),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          final appError = error as AppException;
          return ErrorScreen(
            error: appError,
            onRetry: () => ref.read(newsStateProvider.notifier).refresh(),
          );
        },
      ),
    );
  }

  Widget _buildNewsList(List<NewsArticle> news) {
    if (news.isEmpty) {
      return Builder(
        builder: (context) {
          final scale = MediaQuery.textScalerOf(context).scale(1.0);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No news available',
                  style: TextStyle(fontSize: 18 * scale, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Check back later for updates',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: news.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == news.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final article = news[index];
        return _buildNewsCard(article);
      },
    );
  }

  Widget _buildNewsCard(NewsArticle article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _launchUrl(article.url),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.featuredImageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: article.featuredImageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: Theme.of(context).colorScheme.surface,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: Theme.of(context).colorScheme.surface,
                    child: Icon(
                      Icons.image,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline,
                      semanticLabel: 'Image not available',
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                        semanticLabel: 'Date',
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(article.date),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.open_in_new,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                        semanticLabel: 'Open article',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.excerpt,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
