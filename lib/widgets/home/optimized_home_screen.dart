import 'package:flutter/material.dart';
import '../../features/venues/venues_data.dart' as venues_data;
import '../../models/schedule.dart';
import '../../models/festival_data.dart' as fest_data;
import '../../models/artist.dart';
import '../featured/index.dart';

/// Optimized home screen with lazy loading and performance optimizations
class OptimizedHomeScreen extends StatelessWidget {
  const OptimizedHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero section with optimized background
          SliverAppBar(
            expandedHeight: 300,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(background: _buildHeroSection()),
          ),
          // Content sections
          SliverToBoxAdapter(child: _buildContent(context)),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Optimized background image with progressive loading
        _buildBackgroundImage(),
        // Gradient overlay for better text readability
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black26, Colors.black54],
            ),
          ),
        ),
        // Hero content
        const Positioned(
          bottom: 60,
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                'Buna Festival',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Experience art, culture, and creativity in Varna',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      'assets/BUNA3_BlueStory.png',
      fit: BoxFit.cover,
      // Use a loading placeholder to improve perceived performance
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
      // Error fallback
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF1976D2), // Fallback blue color
          child: const Center(
            child: Icon(Icons.image, size: 64, color: Colors.white54),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Quick actions section
          _buildQuickActions(context),

          const SizedBox(height: 32),

          // Featured content section with lazy loading
          const Text(
            'Featured',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Lazy-loaded dashboard widgets
          ..._buildDashboardWidgets(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickActionButton(
                  icon: Icons.map,
                  label: 'Map',
                  onTap: () {
                    // Navigate to map
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.schedule,
                  label: 'Schedule',
                  onTap: () {
                    // Navigate to schedule
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.people,
                  label: 'Artists',
                  onTap: () {
                    // Navigate to artists
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.place,
                  label: 'Venues',
                  onTap: () {
                    // Navigate to venues
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF1976D2)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDashboardWidgets() {
    // Create widgets lazily to improve initial render performance
    return [
      // Featured Artist Card - Lazy loaded
      FutureBuilder<Widget>(
        future: _buildFeaturedArtistCard(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          return const _DashboardPlaceholder(height: 150);
        },
      ),
      const SizedBox(height: 16),

      // Featured Venue Card - Lazy loaded
      FutureBuilder<Widget>(
        future: _buildFeaturedVenueCard(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          return const _DashboardPlaceholder(height: 120);
        },
      ),
      const SizedBox(height: 16),

      // Next Event Card - Lazy loaded
      FutureBuilder<Widget>(
        future: _buildNextEventCard(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          return const _DashboardPlaceholder(height: 100);
        },
      ),
      const SizedBox(height: 16),

      // News Dashboard Card - Lazy loaded
      FutureBuilder<Widget>(
        future: _buildNewsDashboardCard(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          return const _DashboardPlaceholder(height: 140);
        },
      ),
    ];
  }

  Future<Widget> _buildFeaturedArtistCard() async {
    // Simulate async data loading
    await Future.delayed(const Duration(milliseconds: 100));

    return FeaturedArtistCard(
      artist: Artist(
        id: '1',
        name: 'Featured Artist',
        country: 'International',
        bio: 'Discover amazing artists at Buna Festival.',
        specialty: 'Contemporary Art',
        website: 'https://featuredartist.com',
        socialMedia: ['https://instagram.com/featuredartist'],
      ),
    );
  }

  Future<Widget> _buildFeaturedVenueCard() async {
    await Future.delayed(const Duration(milliseconds: 150));

    return FeaturedVenueCard(
      venue: venues_data.Venue(
        name: 'Main Gallery',
        address: 'Central Varna',
        events: [
          venues_data.Event(
            name: 'Art Exhibition',
            date: '2025-07-01',
            time: '7:00 PM',
          ),
        ],
      ),
    );
  }

  Future<Widget> _buildNextEventCard() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return NextEventCard(
      entry: ScheduleEntry(
        event: venues_data.Event(
          name: 'Opening Ceremony',
          date: '2025-07-01',
          time: '8:00 PM',
        ),
        venue: venues_data.Venue(
          name: 'Main Square',
          address: 'Varna Center',
          events: [],
        ),
      ),
    );
  }

  Future<Widget> _buildNewsDashboardCard() async {
    await Future.delayed(const Duration(milliseconds: 250));

    return NewsDashboardCard(
      article: fest_data.NewsArticle(
        id: 1,
        title: 'Festival Updates',
        content: 'Latest news and updates from Buna Festival.',
        excerpt: 'Stay updated with the latest festival news.',
        date: DateTime.now(),
        featuredImageUrl: null,
        author: 'Festival Team',
        categories: ['News'],
        url: 'https://bunavarna.com/news',
      ),
    );
  }
}

/// Placeholder widget for loading dashboard components
class _DashboardPlaceholder extends StatelessWidget {
  final double height;

  const _DashboardPlaceholder({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
