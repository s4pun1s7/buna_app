import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/common/index.dart';
import '../../models/artist.dart';
import 'artist_service.dart';

/// Artists screen showing all participating artists
class ArtistsScreen extends ConsumerStatefulWidget {
  const ArtistsScreen({super.key});

  @override
  ConsumerState<ArtistsScreen> createState() => _ArtistsScreenState();
}

// Provider for the artist data source (switchable for mock/API)
final artistDataSourceProvider = Provider<ArtistDataSource>((ref) {
  // Swap to ApiArtistDataSource() for real API
  return MockArtistDataSource();
});

class _ArtistsScreenState extends ConsumerState<ArtistsScreen> {
  List<Artist> _artists = [];
  List<Artist> _filteredArtists = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  String _selectedCountry = 'All';

  @override
  void initState() {
    super.initState();
    _loadArtists();
  }

  Future<void> _loadArtists() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Use the data source provider
      final dataSource = ref.read(artistDataSourceProvider);
      final artists = await dataSource.fetchArtists();

      setState(() {
        _artists = artists;
        _filteredArtists = artists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterArtists() {
    setState(() {
      _filteredArtists = _artists.where((artist) {
        final matchesSearch =
            _searchQuery.isEmpty ||
            artist.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            artist.specialty.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            artist.bio.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesCountry =
            _selectedCountry == 'All' || artist.country == _selectedCountry;

        return matchesSearch && matchesCountry;
      }).toList();
    });
  }

  List<String> _getCountries() {
    final countries = _artists.map((artist) => artist.country).toSet().toList();
    countries.sort();
    return ['All', ...countries];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingIndicator();
    }

    if (_error != null) {
      return AppErrorWidget(message: _error, onRetry: _loadArtists);
    }

    if (_artists.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildSearchBar(),
        _buildCountryFilter(),
        Expanded(child: _buildArtistsList()),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search artists...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          _filterArtists();
        },
      ),
    );
  }

  Widget _buildCountryFilter() {
    final countries = _getCountries();

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: countries.length,
        itemBuilder: (context, index) {
          final country = countries[index];
          final isSelected = country == _selectedCountry;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(country),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCountry = country;
                  });
                  _filterArtists();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildArtistsList() {
    if (_filteredArtists.isEmpty) {
      return _buildNoResults();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredArtists.length,
      itemBuilder: (context, index) {
        final artist = _filteredArtists[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => _showArtistDetails(artist),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Artist avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      artist.name.split(' ').map((n) => n[0]).join(''),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      semanticsLabel: 'Artist initials',
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Artist info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artist.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Theme.of(context).colorScheme.outline,
                              semanticLabel: 'Country',
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
                        const SizedBox(height: 8),
                        Text(
                          artist.specialty,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 8),
                        if (artist.bio.isNotEmpty) ...[
                          Text(
                            'Bio: ${artist.bio}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios),
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
            Icons.person_off,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Artists Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Check back later for artist announcements'),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadArtists, child: const Text('Refresh')),
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
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Artists Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Try adjusting your search or filters'),
        ],
      ),
    );
  }

  void _showArtistDetails(Artist artist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(artist.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${artist.specialty}'),
            Text('Country: ${artist.country}'),
            if (artist.bio.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Bio: ${artist.bio}'),
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
