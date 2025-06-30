import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../navigation/app_router.dart';
import '../../widgets/search_widget.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../theme/app_theme.dart';
import '../../features/venues/venues_data.dart';

/// Enhanced home screen with search and better UI
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom app bar with search
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.1),
                      AppTheme.secondaryColor.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buna Festival',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Discover contemporary art in Varna',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Search section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SearchWidget(
                hintText: 'Search venues, events, artists...',
                onSearch: (query) {
                  // Navigate to search results or filter current view
                  if (query.isNotEmpty) {
                    AppRouter.goToVenues(context);
                  }
                },
              ),
            ),
          ),
          
          // Quick actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQuickActions(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Schedule section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Schedule',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildScheduleSection(context, ref),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Favorites section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Favorites',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFavoritesSection(context, ref),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Featured venues
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Venues',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeaturedVenues(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            context,
            icon: Icons.schedule,
            title: 'Schedule',
            subtitle: 'View events',
            color: AppTheme.primaryColor,
            onTap: () => AppRouter.goToVenues(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            context,
            icon: Icons.map,
            title: 'Map',
            subtitle: 'Find venues',
            color: AppTheme.secondaryColor,
            onTap: () => AppRouter.goToMaps(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            context,
            icon: Icons.article,
            title: 'News',
            subtitle: 'Latest updates',
            color: Colors.orange,
            onTap: () => AppRouter.goToNews(context),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withValues(alpha: 0.1),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleSection(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleProvider);
    
    return scheduleAsync.when(
      data: (schedule) {
        if (schedule.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.schedule,
            title: 'No events scheduled',
            subtitle: 'Add events to your schedule to see them here',
            actionText: 'Browse Events',
            onAction: () => AppRouter.goToVenues(context),
          );
        }
        
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...schedule.take(3).map((entry) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.secondaryColor.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.event,
                      color: AppTheme.secondaryColor,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    entry.event.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${entry.venue.name} • ${entry.event.date}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => AppRouter.goToVenues(context),
                )),
                if (schedule.length > 3)
                  TextButton(
                    onPressed: () => AppRouter.goToVenues(context),
                    child: Text('View all ${schedule.length} events'),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stackTrace) => _buildEmptyState(
        context,
        icon: Icons.error_outline,
        title: 'Failed to load schedule',
        subtitle: 'Please try again later',
        actionText: 'Retry',
        onAction: () => ref.refresh(scheduleProvider),
      ),
    );
  }

  Widget _buildFavoritesSection(BuildContext context, WidgetRef ref) {
    final favMgr = ref.watch(favoritesProvider);
    final favVenues = favMgr.favoriteVenues;
    final favEvents = favMgr.favoriteEvents;
    
    if (favVenues.isEmpty && favEvents.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.favorite_border,
        title: 'No favorites yet',
        subtitle: 'Add venues and events to your favorites to see them here',
        actionText: 'Browse Venues',
        onAction: () => AppRouter.goToVenues(context),
      );
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (favVenues.isNotEmpty) ...[
              _buildSectionHeader('Venues', Icons.location_on, AppTheme.secondaryColor),
              const SizedBox(height: 8),
              ...favVenues.take(2).map((venue) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.secondaryColor.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.location_on,
                    color: AppTheme.secondaryColor,
                    size: 20,
                  ),
                ),
                title: Text(venue.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(venue.address, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () => AppRouter.goToVenues(context),
              )),
              if (favVenues.length > 2)
                TextButton(
                  onPressed: () => AppRouter.goToVenues(context),
                  child: Text('View all ${favVenues.length} venues'),
                ),
            ],
            if (favVenues.isNotEmpty && favEvents.isNotEmpty)
              const Divider(height: 24),
            if (favEvents.isNotEmpty) ...[
              _buildSectionHeader('Events', Icons.star, AppTheme.primaryColor),
              const SizedBox(height: 8),
              ...favEvents.take(2).map((event) {
                // Find the venue that contains this event
                final venue = venues.firstWhere(
                  (v) => v.events.contains(event),
                  orElse: () => venues.first,
                );
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.star,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  title: Text(event.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${venue.name} • ${event.date}'),
                  onTap: () => AppRouter.goToVenues(context),
                );
              }),
              if (favEvents.length > 2)
                TextButton(
                  onPressed: () => AppRouter.goToVenues(context),
                  child: Text('View all ${favEvents.length} events'),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedVenues(BuildContext context) {
    final featuredVenues = venues.take(3).toList();
    
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: featuredVenues.length,
        itemBuilder: (context, index) {
          final venue = featuredVenues[index];
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                onTap: () => AppRouter.goToVenues(context),
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryColor.withValues(alpha: 0.1),
                              AppTheme.secondaryColor.withValues(alpha: 0.05),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.location_city,
                            size: 48,
                            color: AppTheme.primaryColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              venue.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              venue.address,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${venue.events.length} events',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.secondaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionText),
            ),
          ],
        ),
      ),
    );
  }
} 