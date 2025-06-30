import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_screen.dart';
import '../../services/error_handler.dart';

/// Sponsor model for the festival
class Sponsor {
  final String id;
  final String name;
  final String category;
  final String? logoUrl;
  final String? website;
  final String? description;
  final SponsorLevel level;

  const Sponsor({
    required this.id,
    required this.name,
    required this.category,
    this.logoUrl,
    this.website,
    this.description,
    required this.level,
  });
}

/// Sponsor levels
enum SponsorLevel {
  platinum,
  gold,
  silver,
  bronze,
  partner,
}

/// Sponsors screen showing all festival sponsors
class SponsorsScreen extends ConsumerStatefulWidget {
  const SponsorsScreen({super.key});

  @override
  ConsumerState<SponsorsScreen> createState() => _SponsorsScreenState();
}

class _SponsorsScreenState extends ConsumerState<SponsorsScreen> {
  List<Sponsor> _sponsors = [];
  List<Sponsor> _filteredSponsors = [];
  bool _isLoading = true;
  String? _error;
  SponsorLevel? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _loadSponsors();
  }

  Future<void> _loadSponsors() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - in real app this would come from API
      final sponsors = [
        Sponsor(
          id: '1',
          name: 'Varna Municipality',
          category: 'Government',
          description: 'Official partner and supporter of Buna Festival, providing venues and infrastructure support.',
          level: SponsorLevel.platinum,
          website: 'https://varna.bg',
        ),
        Sponsor(
          id: '2',
          name: 'Bulgarian National Bank',
          category: 'Financial',
          description: 'Supporting cultural initiatives and promoting Bulgarian arts and culture.',
          level: SponsorLevel.gold,
          website: 'https://bnb.bg',
        ),
        Sponsor(
          id: '3',
          name: 'Varna Free University',
          category: 'Education',
          description: 'Academic partner providing research support and student participation opportunities.',
          level: SponsorLevel.gold,
          website: 'https://vfu.bg',
        ),
        Sponsor(
          id: '4',
          name: 'Bulgarian Cultural Institute',
          category: 'Cultural',
          description: 'Promoting Bulgarian culture and supporting international cultural exchange.',
          level: SponsorLevel.silver,
          website: 'https://bci.bg',
        ),
        Sponsor(
          id: '5',
          name: 'Varna Art Gallery',
          category: 'Arts',
          description: 'Local art institution providing exhibition spaces and curatorial support.',
          level: SponsorLevel.silver,
          website: 'https://varnaartgallery.bg',
        ),
        Sponsor(
          id: '6',
          name: 'Black Sea Tourism',
          category: 'Tourism',
          description: 'Promoting cultural tourism and supporting local cultural events.',
          level: SponsorLevel.bronze,
          website: 'https://blackseatourism.bg',
        ),
        Sponsor(
          id: '7',
          name: 'Varna Port Authority',
          category: 'Infrastructure',
          description: 'Providing logistical support and access to port facilities for installations.',
          level: SponsorLevel.bronze,
          website: 'https://varnaport.bg',
        ),
        Sponsor(
          id: '8',
          name: 'Local Artists Collective',
          category: 'Community',
          description: 'Community partner supporting local artist participation and workshops.',
          level: SponsorLevel.partner,
          website: 'https://localartists.bg',
        ),
        Sponsor(
          id: '9',
          name: 'Varna Cultural Center',
          category: 'Cultural',
          description: 'Providing performance spaces and technical support for festival events.',
          level: SponsorLevel.partner,
          website: 'https://varnacultural.bg',
        ),
        Sponsor(
          id: '10',
          name: 'Bulgarian Arts Foundation',
          category: 'Foundation',
          description: 'Supporting emerging artists and providing grants for festival participants.',
          level: SponsorLevel.partner,
          website: 'https://bulgarianarts.bg',
        ),
      ];

      setState(() {
        _sponsors = sponsors;
        _filteredSponsors = sponsors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterSponsors() {
    setState(() {
      _filteredSponsors = _sponsors.where((sponsor) {
        return _selectedLevel == null || sponsor.level == _selectedLevel;
      }).toList();
    });
  }

  Color _getLevelColor(SponsorLevel level) {
    switch (level) {
      case SponsorLevel.platinum:
        return const Color(0xFFE5E4E2);
      case SponsorLevel.gold:
        return const Color(0xFFFFD700);
      case SponsorLevel.silver:
        return const Color(0xFFC0C0C0);
      case SponsorLevel.bronze:
        return const Color(0xFFCD7F32);
      case SponsorLevel.partner:
        return const Color(0xFF87CEEB);
    }
  }

  String _getLevelName(SponsorLevel level) {
    switch (level) {
      case SponsorLevel.platinum:
        return 'Platinum';
      case SponsorLevel.gold:
        return 'Gold';
      case SponsorLevel.silver:
        return 'Silver';
      case SponsorLevel.bronze:
        return 'Bronze';
      case SponsorLevel.partner:
        return 'Partner';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingIndicator();
    }

    if (_error != null) {
      return ErrorScreen(
        error: AppException(_error ?? 'Unknown error'),
        onRetry: _loadSponsors,
      );
    }

    if (_sponsors.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildLevelFilter(),
        Expanded(
          child: _buildSponsorsList(),
        ),
      ],
    );
  }

  Widget _buildLevelFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: const Text('All'),
              selected: _selectedLevel == null,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedLevel = null;
                  });
                  _filterSponsors();
                }
              },
            ),
          ),
          ...SponsorLevel.values.map((level) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(_getLevelName(level)),
              selected: _selectedLevel == level,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedLevel = level;
                  });
                  _filterSponsors();
                }
              },
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSponsorsList() {
    if (_filteredSponsors.isEmpty) {
      return _buildNoResults();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredSponsors.length,
      itemBuilder: (context, index) {
        final sponsor = _filteredSponsors[index];
        final scale = MediaQuery.textScaleFactorOf(context);
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => _showSponsorDetails(sponsor),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Sponsor logo placeholder
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _getLevelColor(sponsor.level),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            sponsor.name.split(' ').map((n) => n[0]).join(''),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18 * scale,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sponsor.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              sponsor.category,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getLevelColor(sponsor.level),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getLevelName(sponsor.level),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12 * scale,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (sponsor.description != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      sponsor.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (sponsor.website != null)
                        TextButton.icon(
                          onPressed: () {
                            // TODO: Open website
                          },
                          icon: const Icon(Icons.language),
                          label: const Text('Website'),
                        ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Sponsors Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Check back later for sponsor announcements'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadSponsors,
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
            'No Sponsors Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Try adjusting your filter selection'),
        ],
      ),
    );
  }

  void _showSponsorDetails(Sponsor sponsor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(sponsor.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${sponsor.category}'),
            Text('Level: ${_getLevelName(sponsor.level)}'),
            if (sponsor.description != null) ...[
              const SizedBox(height: 8),
              Text('Description: ${sponsor.description}'),
            ],
          ],
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
} 