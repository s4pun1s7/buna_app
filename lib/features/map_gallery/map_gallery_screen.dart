import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/common/index.dart';
import '../../services/error_handler.dart';
import '../../providers/user_provider.dart';

/// Map gallery item model
class MapGalleryItem {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String category;
  final DateTime date;
  final String location;
  final List<String> tags;
  final bool isInteractive;

  const MapGalleryItem({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.date,
    required this.location,
    required this.tags,
    required this.isInteractive,
  });
}

/// Map gallery screen showing festival locations and points of interest
class MapGalleryScreen extends ConsumerStatefulWidget {
  const MapGalleryScreen({super.key});

  @override
  ConsumerState<MapGalleryScreen> createState() => _MapGalleryScreenState();
}

class _MapGalleryScreenState extends ConsumerState<MapGalleryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<MapGalleryItem> _allItems = [];
  List<MapGalleryItem> _filteredItems = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMapGallery();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMapGallery() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - in real app this would come from API
      final items = [
        MapGalleryItem(
          id: '1',
          title: 'Main Square',
          description:
              'The heart of Varna and the primary venue for major festival events. Features the iconic light installation "Urban Dreams" by Elena Rodriguez.',
          category: 'Venue',
          date: DateTime.now().subtract(const Duration(days: 1)),
          location: 'Central Square, Varna',
          tags: ['main venue', 'light art', 'ceremonies'],
          isInteractive: true,
        ),
        MapGalleryItem(
          id: '2',
          title: 'City Gallery',
          description:
              'A modern, purpose-built gallery space showcasing contemporary art exhibitions from international and local artists.',
          category: 'Gallery',
          date: DateTime.now().subtract(const Duration(days: 2)),
          location: '123 Art Street, Varna',
          tags: ['contemporary art', 'exhibitions', 'indoor'],
          isInteractive: true,
        ),
        MapGalleryItem(
          id: '3',
          title: 'Digital Art Pavilion',
          description:
              'Cutting-edge venue for digital art and technology-based installations featuring VR experiences and AI-generated artwork.',
          category: 'Technology',
          date: DateTime.now().subtract(const Duration(days: 3)),
          location: '456 Innovation Boulevard, Varna',
          tags: ['digital art', 'VR', 'AI', 'technology'],
          isInteractive: true,
        ),
        MapGalleryItem(
          id: '4',
          title: 'Seaside Park Environmental Installation',
          description:
              'Large-scale environmental art installation using sustainable materials to address climate change and environmental conservation.',
          category: 'Environmental',
          date: DateTime.now().subtract(const Duration(days: 4)),
          location: 'Seaside Park, Varna',
          tags: ['environmental art', 'sustainability', 'outdoor'],
          isInteractive: true,
        ),
        MapGalleryItem(
          id: '5',
          title: 'Outdoor Amphitheater',
          description:
              'Stunning open-air performance venue located on the Black Sea coast, perfect for live music and theatrical performances.',
          category: 'Performance',
          date: DateTime.now().subtract(const Duration(days: 5)),
          location: 'Seaside Park, Varna',
          tags: ['music', 'theater', 'outdoor', 'performance'],
          isInteractive: true,
        ),
        MapGalleryItem(
          id: '6',
          title: 'Art Studio Complex',
          description:
              'Dedicated space for workshops and masterclasses with multiple studio spaces equipped for various art mediums.',
          category: 'Workshop',
          date: DateTime.now().subtract(const Duration(days: 6)),
          location: '789 Creative Lane, Varna',
          tags: ['workshops', 'masterclasses', 'learning'],
          isInteractive: true,
        ),
        MapGalleryItem(
          id: '7',
          title: 'Underground Theater',
          description:
              'Converted warehouse space transformed into an experimental theater venue with industrial aesthetic.',
          category: 'Theater',
          date: DateTime.now().subtract(const Duration(days: 7)),
          location: '321 Industrial Zone, Varna',
          tags: ['experimental', 'theater', 'underground'],
          isInteractive: true,
        ),
        MapGalleryItem(
          id: '8',
          title: 'Festival Information Center',
          description:
              'Central hub for festival information, ticket sales, and visitor assistance.',
          category: 'Information',
          date: DateTime.now().subtract(const Duration(days: 8)),
          location: 'Festival Square, Varna',
          tags: ['information', 'tickets', 'assistance'],
          isInteractive: false,
        ),
        MapGalleryItem(
          id: '9',
          title: 'Food & Beverage Area',
          description:
              'Culinary zone featuring local and international cuisine, food trucks, and festival bars.',
          category: 'Food',
          date: DateTime.now().subtract(const Duration(days: 9)),
          location: 'Culinary Corner, Varna',
          tags: ['food', 'drinks', 'culinary'],
          isInteractive: false,
        ),
        MapGalleryItem(
          id: '10',
          title: 'Merchandise Shop',
          description:
              'Official festival merchandise store with limited edition items and artist collaborations.',
          category: 'Shopping',
          date: DateTime.now().subtract(const Duration(days: 10)),
          location: 'Festival Market, Varna',
          tags: ['merchandise', 'shopping', 'souvenirs'],
          isInteractive: false,
        ),
      ];

      setState(() {
        _allItems = items;
        _filteredItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterItems() {
    setState(() {
      _filteredItems = _allItems.where((item) {
        final matchesCategory =
            _selectedCategory == 'All' || item.category == _selectedCategory;
        final matchesSearch =
            _searchQuery.isEmpty ||
            item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.description.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            item.tags.any(
              (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()),
            );

        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  List<String> _getCategories() {
    final categories = _allItems.map((item) => item.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'venue':
        return Colors.blue;
      case 'gallery':
        return Colors.purple;
      case 'technology':
        return Colors.cyan;
      case 'environmental':
        return Colors.green;
      case 'performance':
        return Colors.orange;
      case 'workshop':
        return Colors.indigo;
      case 'theater':
        return Colors.pink;
      case 'information':
        return Colors.grey;
      case 'food':
        return Colors.amber;
      case 'shopping':
        return Colors.teal;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'venue':
        return Icons.location_on;
      case 'gallery':
        return Icons.art_track;
      case 'technology':
        return Icons.computer;
      case 'environmental':
        return Icons.eco;
      case 'performance':
        return Icons.music_note;
      case 'workshop':
        return Icons.school;
      case 'theater':
        return Icons.theater_comedy;
      case 'information':
        return Icons.info;
      case 'food':
        return Icons.restaurant;
      case 'shopping':
        return Icons.shopping_bag;
      default:
        return Icons.place;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Gallery'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: _openFullMap,
            tooltip: 'Open full map',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter options',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.grid_view), text: 'Grid'),
            Tab(icon: Icon(Icons.list), text: 'List'),
            Tab(icon: Icon(Icons.map), text: 'Map'),
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
        onRetry: _loadMapGallery,
      );
    }

    if (_allItems.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildSearchBar(),
        _buildCategoryFilter(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildGridView(), _buildListView(), _buildMapView()],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search locations...',
          prefixIcon: Icon(Icons.search, semanticLabel: 'Search'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          _filterItems();
        },
      ),
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
              label: Text(
                category,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                  _filterItems();
                }
              },
              tooltip: 'Filter by $category',
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView() {
    if (_filteredItems.isEmpty) {
      return _buildNoResults();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _buildGridCard(item);
      },
    );
  }

  Widget _buildListView() {
    if (_filteredItems.isEmpty) {
      return _buildNoResults();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _buildListCard(item);
      },
    );
  }

  Widget _buildMapView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 64, color: Theme.of(context).primaryColor),
          const SizedBox(height: 16),
          Text(
            'Interactive Map',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Interactive map view coming soon...'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _openFullMap,
            child: const Text('Open Full Map'),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(MapGalleryItem item) {
    return Card(
      child: InkWell(
        onTap: () => _showItemDetails(item),
        borderRadius: BorderRadius.circular(12),
        child: Builder(
          builder: (context) {
            final scale = MediaQuery.textScalerOf(context).scale(1.0);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(
                        item.category,
                      ).withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            _getCategoryIcon(item.category),
                            size: 48,
                            color: _getCategoryColor(item.category),
                            semanticLabel: item.category,
                          ),
                        ),
                        if (item.isInteractive)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Interactive',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10 * scale,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Content
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.location,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              _getCategoryIcon(item.category),
                              size: 16,
                              color: _getCategoryColor(item.category),
                              semanticLabel: item.category,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.category,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: _getCategoryColor(item.category),
                                      fontWeight: FontWeight.w500,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openFullMap() {
    // In a real app, this would navigate to a full map screen or open a map modal
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Full Map'),
        content: const Text('Full interactive map coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    // In a real app, this would show a filter dialog for categories/tags
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Options'),
        content: const Text('Filter dialog coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No locations found.'),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No results match your search.'),
        ],
      ),
    );
  }

  Widget _buildListCard(MapGalleryItem item) {
    return Card(
      child: ListTile(
        leading: Icon(
          _getCategoryIcon(item.category),
          color: _getCategoryColor(item.category),
        ),
        title: Text(item.title),
        subtitle: Text(item.location),
        trailing: item.isInteractive
            ? const Icon(Icons.touch_app, color: Colors.blue)
            : null,
        onTap: () => _showItemDetails(item),
      ),
    );
  }

  void _showItemDetails(MapGalleryItem item) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description),
            const SizedBox(height: 8),
            Text('Location: ${item.location}'),
            Text('Category: ${item.category}'),
            if (item.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Tags: ${item.tags.join(", ")}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
    // After dialog closes, check authentication
    final user = ref.read(userProvider).asData?.value;
    if (user == null) {
      // Not logged in, show login prompt
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Required'),
            content: const Text('Please log in to access this feature.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    }
  }
}
