import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/common/index.dart';
import '../../providers/user_provider.dart';
import '../../widgets/navigation/buna_app_bar.dart';

/// Social media post model
class SocialPost {
  final String id;
  final String platform;
  final String username;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  final int likes;
  final int comments;
  final int shares;
  final String? hashtags;

  const SocialPost({
    required this.id,
    required this.platform,
    required this.username,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.shares,
    this.hashtags,
  });
}

/// Social media screen showing festival social media feeds
class SocialScreen extends ConsumerStatefulWidget {
  const SocialScreen({super.key});

  @override
  ConsumerState<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends ConsumerState<SocialScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<SocialPost> _allPosts = [];
  List<SocialPost> _filteredPosts = [];
  bool _isLoading = true;
  String? _error;
  String _selectedPlatform = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSocialPosts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSocialPosts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - in real app this would come from social media APIs
      final posts = [
        SocialPost(
          id: '1',
          platform: 'Instagram',
          username: '@bunafestival',
          content:
              'The opening ceremony was absolutely magical! ✨ Light installations transformed the city square into a wonderland. #BunaFestival2024 #Art #Varna',
          imageUrl: null,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          likes: 1247,
          comments: 89,
          shares: 23,
          hashtags: '#BunaFestival2024 #Art #Varna',
        ),
        SocialPost(
          id: '2',
          platform: 'Twitter',
          username: '@BunaFestival',
          content:
              'Just announced: Digital Art & VR Experience extended by popular demand! 🎨🕶️ Don\'t miss this cutting-edge showcase. Tickets available at the venue.',
          imageUrl: null,
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          likes: 892,
          comments: 156,
          shares: 67,
          hashtags: '#DigitalArt #VR #BunaFestival',
        ),
        SocialPost(
          id: '3',
          platform: 'Facebook',
          username: 'Buna Festival',
          content:
              'Behind the scenes: Our amazing volunteers setting up the environmental art installation. These sustainable sculptures are made entirely from recycled materials! 🌱♻️',
          imageUrl: null,
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          likes: 2156,
          comments: 234,
          shares: 145,
          hashtags: '#EnvironmentalArt #Sustainability #Volunteers',
        ),
        SocialPost(
          id: '4',
          platform: 'Instagram',
          username: '@elenarodriguez_art',
          content:
              'Thrilled to be part of Buna Festival 2024! My light installation "Urban Dreams" is now live at the Main Square. Come experience the magic! ✨ #LightArt #BunaFestival',
          imageUrl: null,
          timestamp: DateTime.now().subtract(const Duration(hours: 8)),
          likes: 3421,
          comments: 198,
          shares: 89,
          hashtags: '#LightArt #BunaFestival #UrbanDreams',
        ),
        SocialPost(
          id: '5',
          platform: 'Twitter',
          username: '@VarnaCity',
          content:
              'Proud to host Buna Festival 2024! The city is alive with creativity and culture. Check out the amazing installations throughout Varna! 🎨🏛️',
          imageUrl: null,
          timestamp: DateTime.now().subtract(const Duration(hours: 10)),
          likes: 1567,
          comments: 89,
          shares: 234,
          hashtags: '#Varna #BunaFestival #Culture',
        ),
        SocialPost(
          id: '6',
          platform: 'Facebook',
          username: 'Varna Art Gallery',
          content:
              'The contemporary art exhibition is now open! Featuring works from international and local artists. Free guided tours available daily at 2 PM. 🎨',
          imageUrl: null,
          timestamp: DateTime.now().subtract(const Duration(hours: 12)),
          likes: 987,
          comments: 67,
          shares: 34,
          hashtags: '#ContemporaryArt #Exhibition #VarnaArtGallery',
        ),
        SocialPost(
          id: '7',
          platform: 'Instagram',
          username: '@hiroshi_tanaka',
          content:
              'Excited to showcase my AI-generated artwork at Buna Festival! The Digital Art Pavilion is a perfect space for exploring the future of creativity. 🤖🎨',
          imageUrl: null,
          timestamp: DateTime.now().subtract(const Duration(hours: 14)),
          likes: 2789,
          comments: 234,
          shares: 156,
          hashtags: '#AIArt #DigitalArt #BunaFestival',
        ),
        SocialPost(
          id: '8',
          platform: 'Twitter',
          username: '@BulgarianArts',
          content:
              'Buna Festival is a celebration of artistic diversity! From traditional Bulgarian crafts to cutting-edge digital art, there\'s something for everyone. 🎭🎨',
          imageUrl: null,
          timestamp: DateTime.now().subtract(const Duration(hours: 16)),
          likes: 1234,
          comments: 78,
          shares: 45,
          hashtags: '#BulgarianArts #CulturalDiversity #BunaFestival',
        ),
      ];

      setState(() {
        _allPosts = posts;
        _filteredPosts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterPosts() {
    setState(() {
      _filteredPosts = _allPosts.where((post) {
        return _selectedPlatform == 'All' || post.platform == _selectedPlatform;
      }).toList();
    });
  }

  List<String> _getPlatforms() {
    final platforms = _allPosts.map((post) => post.platform).toSet().toList();
    platforms.sort();
    return ['All', ...platforms];
  }

  Color _getPlatformColor(String platform) {
    switch (platform) {
      case 'Instagram':
        return const Color(0xFFE4405F);
      case 'Twitter':
        return const Color(0xFF1DA1F2);
      case 'Facebook':
        return const Color(0xFF1877F2);
      default:
        return Theme.of(context).primaryColor;
    }
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform) {
      case 'Instagram':
        return Icons.camera_alt;
      case 'Twitter':
        return Icons.flutter_dash;
      case 'Facebook':
        return Icons.facebook;
      default:
        return Icons.share;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BunaAppBar(
        title: 'Social Feed',
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareFestival,
            tooltip: 'Share festival',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSocialPosts,
            tooltip: 'Refresh feed',
          ),
        ],
        // TabBar remains as bottom property if needed
        // bottom: TabBar(...)
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingIndicator();
    }

    if (_error != null) {
      return AppErrorWidget(message: _error, onRetry: _loadSocialPosts);
    }

    if (_allPosts.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildPlatformFilter(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTimelineView(),
              _buildTrendingView(),
              _buildFavoritesView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformFilter() {
    final platforms = _getPlatforms();

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: platforms.length,
        itemBuilder: (context, index) {
          final platform = platforms[index];
          final isSelected = platform == _selectedPlatform;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(platform),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedPlatform = platform;
                  });
                  _filterPosts();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineView() {
    if (_filteredPosts.isEmpty) {
      return _buildNoResults();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredPosts.length,
      itemBuilder: (context, index) {
        final post = _filteredPosts[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildTrendingView() {
    // Sort posts by engagement (likes + comments + shares)
    final trendingPosts = List<SocialPost>.from(_filteredPosts);
    trendingPosts.sort(
      (a, b) => (b.likes + b.comments + b.shares).compareTo(
        a.likes + a.comments + a.shares,
      ),
    );

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trendingPosts.length,
      itemBuilder: (context, index) {
        final post = trendingPosts[index];

        return _buildPostCard(post);
      },
    );
  }

  Widget _buildFavoritesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Favorites Yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Like posts to see them here'),
        ],
      ),
    );
  }

  Widget _buildPostCard(SocialPost post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showPostOptions(post),
        borderRadius: BorderRadius.circular(12),
        child: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _getPlatformColor(post.platform),
                        child: Icon(
                          _getPlatformIcon(post.platform),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${post.platform} • ${_formatTimestamp(post.timestamp)}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () => _showPostOptions(post),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Content
                  Text(post.content),
                  if (post.hashtags != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      post.hashtags!,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  // Engagement
                  Row(
                    children: [
                      _buildEngagementItem(
                        Icons.favorite,
                        post.likes.toString(),
                      ),
                      const SizedBox(width: 16),
                      _buildEngagementItem(
                        Icons.comment,
                        post.comments.toString(),
                      ),
                      const SizedBox(width: 16),
                      _buildEngagementItem(Icons.share, post.shares.toString()),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () => _toggleFavorite(post),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () => _sharePost(post),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEngagementItem(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 4),
        Text(
          count,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.social_distance,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Social Posts Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Check back later for social media updates'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadSocialPosts,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_list_off,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Posts Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Try adjusting your filter selection'),
        ],
      ),
    );
  }

  void _showPostOptions(SocialPost post) {
    final userAsync = ref.read(userProvider);
    final isAnonymous = userAsync.value != null && userAsync.value!.isAnonymous;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Post'),
              onTap: isAnonymous
                  ? () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please log in to use social features.',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  : () {
                      Navigator.pop(context);
                      _sharePost(post);
                    },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Add to Favorites'),
              onTap: isAnonymous
                  ? () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please log in to use social features.',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  : () {
                      Navigator.pop(context);
                      _toggleFavorite(post);
                    },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report Post'),
              onTap: isAnonymous
                  ? () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please log in to use social features.',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  : () {
                      Navigator.pop(context);
                      _reportPost(post);
                    },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(SocialPost post) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${post.username} to favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _sharePost(SocialPost post) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${post.username}\'s post'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _reportPost(SocialPost post) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reported ${post.username}\'s post'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareFestival() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing Buna Festival'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
