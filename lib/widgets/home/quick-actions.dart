import 'package:flutter/material.dart';
import '../../features/venues/venues_data.dart' as venues_data;

import '../../models/schedule.dart';
import '../../models/festival_data.dart' as fest_data;
import '../../models/artist.dart';
import 'package:buna_app/l10n/app_localizations.dart';
import '../featured/index.dart';

// Placeholder widget for loading dashboard components
class DashboardPlaceholder extends StatelessWidget {
  final double height;

  const DashboardPlaceholder({super.key, required this.height});

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
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroSection(context),
            ),
          ),
          // Content sections
          SliverToBoxAdapter(child: _buildContent(context)),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    try {
      final l10n = AppLocalizations.of(context);
      return Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundImage(),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black26, Colors.black54],
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n?.homeLocation ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  l10n?.homeTitle ?? '',
                  style: const TextStyle(
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
                const SizedBox(height: 8),
                Text(
                  l10n?.homeSubtitle ?? '',
                  style: const TextStyle(
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
    } catch (e) {
      debugPrint(
        '[OptimizedHomeScreen] Error in _buildHeroSection: 0{e.toString()}',
      );
      debugPrint('[OptimizedHomeScreen] Stack: 0{stack.toString()}');
      return Container(
        color: Colors.red[50],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 32),
              const SizedBox(height: 8),
              Text(
                'Error loading hero section',
                style: TextStyle(color: Colors.red),
              ),
              Text(e.toString(), style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildBackgroundImage() {
    // Use 8.jpeg as the home screen background, larger and aligned to the right
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: 340, // Even larger height
        width: 300, // Wider for more impact
        child: Image.asset(
          'assets/images/8.jpeg',
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: child,
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFF1976D2),
              child: const Center(
                child: Icon(Icons.image, size: 64, color: Colors.white54),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    try {
      final l10n = AppLocalizations.of(context);
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
            Text(
              l10n?.homeFeatured ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Lazy-loaded dashboard widgets
            ..._buildDashboardWidgets(context),

            const SizedBox(height: 32),
          ],
        ),
      );
    } catch (e) {
      debugPrint(
        '[OptimizedHomeScreen] Error in _buildContent: 0{e.toString()}',
      );
      debugPrint('[OptimizedHomeScreen] Stack: 0{stack.toString()}');
      return Container(
        color: Colors.red[50],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 32),
              const SizedBox(height: 8),
              Text(
                'Error loading content',
                style: TextStyle(color: Colors.red),
              ),
              Text(e.toString(), style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildQuickActions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.homeQuickActions ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickActionButton(
                  icon: Icons.map,
                  label: l10n?.homeMap ?? '',
                  onTap: () {
                    // Navigate to map
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.schedule,
                  label: l10n?.homeSchedule ?? '',
                  onTap: () {
                    // Navigate to schedule
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.people,
                  label: l10n?.homeArtists ?? '',
                  onTap: () {
                    // Navigate to artists
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.place,
                  label: l10n?.homeVenues ?? '',
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

  List<Widget> _buildDashboardWidgets(BuildContext context) {
    // Create widgets lazily to improve initial render performance
    return [
      FutureBuilder<Widget>(
        future: _buildFeaturedArtistCard(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          return const DashboardPlaceholder(height: 150);
        },
      ),
      const SizedBox(height: 16),
      FutureBuilder<Widget>(
        future: _buildFeaturedVenueCard(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          return const DashboardPlaceholder(height: 120);
        },
      ),
      const SizedBox(height: 16),
      FutureBuilder<Widget>(
        future: _buildNextEventCard(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          return const DashboardPlaceholder(height: 100);
        },
      ),
      const SizedBox(height: 16),
      FutureBuilder<Widget>(
        future: _buildNewsDashboardCard(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          return const DashboardPlaceholder(height: 140);
        },
      ),
    ];
  }

  Future<Widget> _buildFeaturedArtistCard() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return FeaturedArtistCard(
      artist: Artist(
        id: '1',
        name: 'Featured Artist',
        country: 'International',
        bio: 'Amazing artist bio',
        specialty: 'Music',
        website: 'https://featuredartist.com',
        socialMedia: ['https://instagram.com/featuredartist'],
      ),
    );
  }

  Future<Widget> _buildFeaturedVenueCard() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return FeaturedVenueCard(
      venue: venues_data.Venue(
        name: 'Featured Venue',
        address: '123 Festival Street',
        events: [
          venues_data.Event(
            name: 'Amazing Event',
            date: 'Jul 1, 2025',
            time: '19:00',
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
          name: 'Next Event',
          date: 'Jul 1, 2025',
          time: '20:00',
        ),
        venue: venues_data.Venue(
          name: 'Event Venue',
          address: '456 Event Street',
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
        title: 'Latest News',
        content: 'Amazing festival news content',
        excerpt: 'Exciting festival updates',
        date: DateTime.now(),
        featuredImageUrl: null,
        author: 'Festival Team',
        categories: ['News'],
        url: '',
      ),
    );
  }
}
