import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/common/index.dart';

/// AR experience model
class ARExperience {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String category;
  final bool isAvailable;
  final List<String> features;
  final String instructions;

  const ARExperience({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.isAvailable,
    required this.features,
    required this.instructions,
  });
}

/// AR screen for augmented reality experiences
class ARScreen extends ConsumerStatefulWidget {
  const ARScreen({super.key});

  @override
  ConsumerState<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends ConsumerState<ARScreen> {
  List<ARExperience> _experiences = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadARExperiences();
  }

  Future<void> _loadARExperiences() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - in real app this would come from API
      final experiences = [
        ARExperience(
          id: '1',
          title: 'Virtual Art Gallery',
          description:
              'Explore a virtual art gallery with 3D sculptures and interactive installations.',
          category: 'Art',
          isAvailable: true,
          features: [
            '3D art sculptures',
            'Interactive installations',
            'Artist information',
            'Virtual tours',
          ],
          instructions:
              'Point your camera at any flat surface to place the virtual gallery.',
        ),
        ARExperience(
          id: '2',
          title: 'Festival Map Overlay',
          description:
              'See festival venues and events overlaid on the real world.',
          category: 'Navigation',
          isAvailable: true,
          features: [
            'Real-time venue locations',
            'Event directions',
            'Distance indicators',
            'Route optimization',
          ],
          instructions:
              'Point your camera at the ground to see the festival map overlay.',
        ),
        ARExperience(
          id: '3',
          title: 'Artist Stories',
          description: 'Watch artists tell their stories through AR holograms.',
          category: 'Stories',
          isAvailable: true,
          features: [
            'Holographic interviews',
            'Behind-the-scenes content',
            'Interactive Q&A',
            'Personal anecdotes',
          ],
          instructions:
              'Find artist markers around the festival to trigger holographic stories.',
        ),
        ARExperience(
          id: '4',
          title: 'Interactive Light Show',
          description:
              'Create your own light show using hand gestures and movements.',
          category: 'Interactive',
          isAvailable: true,
          features: [
            'Gesture recognition',
            'Custom light patterns',
            'Music synchronization',
            'Social sharing',
          ],
          instructions: 'Use hand gestures to control the virtual light show.',
        ),
        ARExperience(
          id: '5',
          title: 'Historical Varna',
          description: 'See how Varna looked in different historical periods.',
          category: 'History',
          isAvailable: false,
          features: [
            'Historical reconstructions',
            'Time period comparisons',
            'Educational content',
            'Cultural insights',
          ],
          instructions:
              'Point your camera at historical buildings to see past reconstructions.',
        ),
        ARExperience(
          id: '6',
          title: 'Environmental Art',
          description:
              'Experience environmental art installations that respond to your location.',
          category: 'Environmental',
          isAvailable: true,
          features: [
            'Location-based art',
            'Environmental awareness',
            'Interactive elements',
            'Educational content',
          ],
          instructions:
              'Walk around the festival to discover location-based environmental art.',
        ),
        ARExperience(
          id: '7',
          title: 'Virtual Performance',
          description: 'Watch virtual performances by festival artists.',
          category: 'Performance',
          isAvailable: true,
          features: [
            'Virtual concerts',
            'Dance performances',
            'Theater shows',
            'Exclusive content',
          ],
          instructions: 'Find performance markers to watch virtual shows.',
        ),
        ARExperience(
          id: '8',
          title: 'Festival Selfie Studio',
          description:
              'Take AR-enhanced selfies with festival-themed filters and effects.',
          category: 'Social',
          isAvailable: true,
          features: [
            'Festival filters',
            'AR effects',
            'Social sharing',
            'Photo contests',
          ],
          instructions:
              'Point your camera at yourself to access festival selfie filters.',
        ),
      ];

      setState(() {
        _experiences = experiences;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterExperiences() {
    // No need to update _selectedCategory or _selectedExperience
  }

  List<String> _getCategories() {
    final categories = _experiences.map((exp) => exp.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'art':
        return Colors.purple;
      case 'navigation':
        return Colors.blue;
      case 'stories':
        return Colors.green;
      case 'interactive':
        return Colors.orange;
      case 'history':
        return Colors.brown;
      case 'environmental':
        return Colors.teal;
      case 'performance':
        return Colors.pink;
      case 'social':
        return Colors.indigo;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'art':
        return Icons.palette;
      case 'navigation':
        return Icons.map;
      case 'stories':
        return Icons.book;
      case 'interactive':
        return Icons.touch_app;
      case 'history':
        return Icons.history;
      case 'environmental':
        return Icons.eco;
      case 'performance':
        return Icons.theater_comedy;
      case 'social':
        return Icons.people;
      default:
        return Icons.view_in_ar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Experiences'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showARSettings,
            tooltip: 'AR settings',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelp,
            tooltip: 'Help',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingIndicator();
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading AR Experiences',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadARExperiences,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_experiences.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildHeader(),
        _buildCategoryFilter(),
        Expanded(child: _buildExperiencesList()),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.view_in_ar,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Augmented Reality',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Experience the festival in a whole new way with our AR features. Point your camera and explore virtual content overlaid on the real world.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
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
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                  _filterExperiences();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildExperiencesList() {
    final filteredExperiences = _experiences.where((exp) {
      return _selectedCategory == 'All' || exp.category == _selectedCategory;
    }).toList();

    if (filteredExperiences.isEmpty) {
      return _buildNoResults();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredExperiences.length,
      itemBuilder: (context, index) {
        final experience = filteredExperiences[index];
        return _buildExperienceCard(experience);
      },
    );
  }

  Widget _buildExperienceCard(ARExperience experience) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _selectExperience(experience),
        borderRadius: BorderRadius.circular(12),
        child: Builder(
          builder: (context) {
            final scale = MediaQuery.textScalerOf(context).scale(1.0);
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _getCategoryColor(experience.category),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getCategoryIcon(experience.category),
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              experience.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              experience.category,
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
                      if (!experience.isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Coming Soon',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12 * scale,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(experience.description),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: experience.features
                        .map(
                          (feature) => Chip(
                            label: Text(
                              feature,
                              style: TextStyle(fontSize: 12 * scale),
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.1),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: experience.isAvailable
                          ? () => _launchExperience(experience)
                          : null,
                      icon: const Icon(Icons.view_in_ar),
                      label: Text(
                        experience.isAvailable ? 'Launch AR' : 'Coming Soon',
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.view_in_ar,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No AR Experiences Available',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Check back later for AR content'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadARExperiences,
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
            'No Experiences Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Try adjusting your filter selection'),
        ],
      ),
    );
  }

  void _selectExperience(ARExperience experience) {
    // No need to update _selectedExperience
    _showExperienceDetails(experience);
  }

  void _showExperienceDetails(ARExperience experience) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(experience.category),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(experience.category),
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          experience.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(experience.category),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(experience.description),
              const SizedBox(height: 16),
              Text(
                'Features:',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...experience.features.map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(feature)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Instructions:',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(experience.instructions),
              const Spacer(),
              if (experience.isAvailable)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _launchExperience(experience);
                    },
                    icon: const Icon(Icons.view_in_ar),
                    label: const Text('Launch AR Experience'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchExperience(ARExperience experience) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Launch ${experience.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This will open the AR camera view.'),
            const SizedBox(height: 16),
            Text('Instructions: ${experience.instructions}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openARCamera(experience);
            },
            child: const Text('Launch'),
          ),
        ],
      ),
    );
  }

  void _openARCamera(ARExperience experience) {
    // In a real app, this would open the AR camera view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening AR camera for ${experience.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showARSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AR Settings'),
        content: const Text(
          'AR quality and performance settings coming soon...',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AR Help'),
        content: const Text(
          '• Make sure you have good lighting for better AR tracking\n'
          '• Keep your device steady while using AR features\n'
          '• AR experiences work best on flat surfaces\n'
          '• Some features may require camera permissions\n'
          '• For best performance, close other apps while using AR',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
