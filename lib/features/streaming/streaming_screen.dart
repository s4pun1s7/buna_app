import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_screen.dart';
import '../../services/error_handler.dart';
import '../../providers/user_provider.dart';

/// Stream model for the festival
class Stream {
  final String id;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isLive;
  final bool isUpcoming;
  final String? streamUrl;
  final int viewers;
  final String category;

  const Stream({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    required this.startTime,
    this.endTime,
    required this.isLive,
    required this.isUpcoming,
    this.streamUrl,
    required this.viewers,
    required this.category,
  });
}

/// Streaming screen for live festival content
class StreamingScreen extends ConsumerStatefulWidget {
  const StreamingScreen({super.key});

  @override
  ConsumerState<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends ConsumerState<StreamingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Stream> _allStreams = [];
  List<Stream> _filteredStreams = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadStreams();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStreams() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - in real app this would come from streaming API
      final streams = [
        Stream(
          id: '1',
          title: 'Opening Ceremony Live',
          description: 'Watch the spectacular opening ceremony of Buna Festival 2024 with live light shows and performances.',
          startTime: DateTime.now().subtract(const Duration(hours: 2)),
          isLive: true,
          isUpcoming: false,
          viewers: 1247,
          category: 'Ceremony',
        ),
        Stream(
          id: '2',
          title: 'Artist Workshop: Digital Art Creation',
          description: 'Join Hiroshi Tanaka for an interactive workshop on creating digital art using AI tools.',
          startTime: DateTime.now().add(const Duration(hours: 1)),
          isLive: false,
          isUpcoming: true,
          viewers: 0,
          category: 'Workshop',
        ),
        Stream(
          id: '3',
          title: 'Live Music Performance',
          description: 'Enjoy live music from local and international artists at the Outdoor Amphitheater.',
          startTime: DateTime.now().add(const Duration(hours: 3)),
          isLive: false,
          isUpcoming: true,
          viewers: 0,
          category: 'Music',
        ),
        Stream(
          id: '4',
          title: 'Behind the Scenes: Installation Setup',
          description: 'Go behind the scenes as artists set up their installations and share their creative process.',
          startTime: DateTime.now().subtract(const Duration(hours: 1)),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          isLive: true,
          isUpcoming: false,
          viewers: 456,
          category: 'Behind the Scenes',
        ),
        Stream(
          id: '5',
          title: 'Curator Talk: Contemporary Art Trends',
          description: 'Join our curators for an insightful discussion about contemporary art trends and the festival\'s artistic vision.',
          startTime: DateTime.now().add(const Duration(hours: 4)),
          isLive: false,
          isUpcoming: true,
          viewers: 0,
          category: 'Talk',
        ),
        Stream(
          id: '6',
          title: 'Venue Tour: Digital Art Pavilion',
          description: 'Take a virtual tour of the Digital Art Pavilion and explore the cutting-edge installations.',
          startTime: DateTime.now().add(const Duration(hours: 2)),
          isLive: false,
          isUpcoming: true,
          viewers: 0,
          category: 'Tour',
        ),
        Stream(
          id: '7',
          title: 'Artist Interview: Elena Rodriguez',
          description: 'Exclusive interview with light artist Elena Rodriguez about her installation "Urban Dreams".',
          startTime: DateTime.now().add(const Duration(hours: 5)),
          isLive: false,
          isUpcoming: true,
          viewers: 0,
          category: 'Interview',
        ),
        Stream(
          id: '8',
          title: 'Festival Highlights Reel',
          description: 'Relive the best moments from the first week of Buna Festival 2024.',
          startTime: DateTime.now().subtract(const Duration(hours: 6)),
          isLive: false,
          isUpcoming: false,
          viewers: 0,
          category: 'Highlights',
        ),
      ];

      setState(() {
        _allStreams = streams;
        _filteredStreams = streams;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterStreams() {
    setState(() {
      _filteredStreams = _allStreams.where((stream) {
        return _selectedCategory == 'All' || stream.category == _selectedCategory;
      }).toList();
    });
  }

  List<String> _getCategories() {
    final categories = _allStreams.map((stream) => stream.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = time.difference(now);

    if (difference.isNegative) {
      return 'Started ${difference.inHours.abs()}h ago';
    } else if (difference.inMinutes < 60) {
      return 'In ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'In ${difference.inHours}h';
    } else {
      return 'In ${difference.inDays}d';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Streams'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showStreamSettings,
            tooltip: 'Stream settings',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.live_tv), text: 'Live'),
            Tab(icon: Icon(Icons.schedule), text: 'Upcoming'),
            Tab(icon: Icon(Icons.history), text: 'Past'),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingIndicator();
    }

    if (_error != null) {
      return ErrorScreen(
        error: AppException(_error!),
        onRetry: _loadStreams,
      );
    }

    if (_allStreams.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildCategoryFilter(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildLiveStreams(),
              _buildUpcomingStreams(),
              _buildPastStreams(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    final categories = _getCategories();
    
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == _selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                  _filterStreams();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLiveStreams() {
    final liveStreams = _filteredStreams.where((stream) => stream.isLive).toList();
    
    if (liveStreams.isEmpty) {
      return _buildNoLiveStreams();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: liveStreams.length,
      itemBuilder: (context, index) {
        final stream = liveStreams[index];
        return _buildStreamCard(stream);
      },
    );
  }

  Widget _buildUpcomingStreams() {
    final upcomingStreams = _filteredStreams.where((stream) => stream.isUpcoming).toList();
    
    if (upcomingStreams.isEmpty) {
      return _buildNoUpcomingStreams();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: upcomingStreams.length,
      itemBuilder: (context, index) {
        final stream = upcomingStreams[index];
        return _buildStreamCard(stream);
      },
    );
  }

  Widget _buildPastStreams() {
    final pastStreams = _filteredStreams.where((stream) => 
      !stream.isLive && !stream.isUpcoming
    ).toList();
    
    if (pastStreams.isEmpty) {
      return _buildNoPastStreams();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pastStreams.length,
      itemBuilder: (context, index) {
        final stream = pastStreams[index];
        return _buildStreamCard(stream);
      },
    );
  }

  Widget _buildStreamCard(Stream stream) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _watchStream(stream),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.live_tv,
                      size: 64,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  if (stream.isLive)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (stream.viewers > 0)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${stream.viewers}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(stream.category),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          stream.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatTime(stream.startTime),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stream.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stream.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_filled,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        stream.isLive ? 'Watch Live' : 
                        stream.isUpcoming ? 'Set Reminder' : 'Watch Replay',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoLiveStreams() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.live_tv,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Live Streams',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Check the upcoming tab for scheduled streams'),
        ],
      ),
    );
  }

  Widget _buildNoUpcomingStreams() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Upcoming Streams',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Check back later for new streams'),
        ],
      ),
    );
  }

  Widget _buildNoPastStreams() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Past Streams',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Past streams will appear here'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam_off,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Streams Available',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Check back later for live festival content'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadStreams,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'ceremony':
        return Colors.purple;
      case 'workshop':
        return Colors.blue;
      case 'music':
        return Colors.orange;
      case 'behind the scenes':
        return Colors.grey;
      case 'talk':
        return Colors.green;
      case 'tour':
        return Colors.teal;
      case 'interview':
        return Colors.indigo;
      case 'highlights':
        return Colors.amber;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  void _watchStream(Stream stream) {
    final userAsync = ref.read(userProvider);
    final isAnonymous = userAsync != null && userAsync.value != null && userAsync.value!.isAnonymous;
    if (stream.isLive) {
      _showLiveStream(stream);
    } else if (stream.isUpcoming) {
      if (isAnonymous) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to set reminders.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        _setReminder(stream);
      }
    } else {
      _showReplay(stream);
    }
  }

  void _showLiveStream(Stream stream) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stream.title),
        content: const Text('Live stream player would open here...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _setReminder(Stream stream) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder set for ${stream.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showReplay(Stream stream) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stream.title),
        content: const Text('Replay player would open here...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showStreamSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stream Settings'),
        content: const Text('Stream quality and notification settings coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
} 