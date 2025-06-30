import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/feature_flags.dart';
import '../../navigation/app_router.dart';
import '../../widgets/buna_logo.dart';

/// Home screen with feature flag integration
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(context),
          const SizedBox(height: 24),
          if (FeatureFlags.enableSchedule) _buildQuickAccessSection(context),
          if (FeatureFlags.enableNews) _buildNewsSection(context),
          if (FeatureFlags.enableArtists) _buildArtistsSection(context),
          if (FeatureFlags.enableStreaming) _buildStreamingSection(context),
          if (FeatureFlags.enableQRScanner) _buildInteractiveSection(context),
          const SizedBox(height: 24),
          _buildFeatureStatusSection(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const BunaLogo(
                  width: 48,
                  height: 48,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Buna Festival 2024',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Art & Culture Festival',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Experience three weeks of incredible art, music, and culture in the beautiful city of Varna.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection(BuildContext context) {
    final quickAccessItems = <Widget>[
      if (FeatureFlags.enableSchedule)
        _buildQuickAccessCard(
          context,
          icon: Icons.schedule,
          title: 'Schedule',
          subtitle: 'View events',
          onTap: () => AppRouter.goToSchedule(context),
        ),
      if (FeatureFlags.enableVenues)
        _buildQuickAccessCard(
          context,
          icon: Icons.location_on,
          title: 'Venues',
          subtitle: 'Find locations',
          onTap: () => AppRouter.goToVenues(context),
        ),
      if (FeatureFlags.enableMaps)
        _buildQuickAccessCard(
          context,
          icon: Icons.map,
          title: 'Map',
          subtitle: 'Navigate festival',
          onTap: () => AppRouter.goToMaps(context),
        ),
      if (FeatureFlags.enableTicketing)
        _buildQuickAccessCard(
          context,
          icon: Icons.confirmation_number,
          title: 'Tickets',
          subtitle: 'Get passes',
          onTap: () => AppRouter.goToTicketing(context),
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: quickAccessItems.length,
          itemBuilder: (context, index) => quickAccessItems[index],
        ),
      ],
    );
  }

  Widget _buildNewsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              'Latest News',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => AppRouter.goToNews(context),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Festival Opening Announced'),
            subtitle: const Text('The opening ceremony will feature spectacular light shows...'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => AppRouter.goToNews(context),
          ),
        ),
      ],
    );
  }

  Widget _buildArtistsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              'Featured Artists',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => AppRouter.goToArtists(context),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: const Text('Elena Rodriguez'),
            subtitle: const Text('Light Artist'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => AppRouter.goToArtists(context),
          ),
        ),
      ],
    );
  }

  Widget _buildStreamingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              'Live Now',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => AppRouter.goToStreaming(context),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.live_tv,
                color: Colors.white,
              ),
            ),
            title: const Text('Opening Ceremony'),
            subtitle: const Text('Live • 1.2K watching'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => AppRouter.goToStreaming(context),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Interactive Features',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (FeatureFlags.enableQRScanner)
              Expanded(
                child: _buildInteractiveCard(
                  context,
                  icon: Icons.qr_code_scanner,
                  title: 'QR Scanner',
                  subtitle: 'Scan codes',
                  onTap: () => AppRouter.goToQR(context),
                ),
              ),
            if (FeatureFlags.enableQRScanner && FeatureFlags.enableAR)
              const SizedBox(width: 12),
            if (FeatureFlags.enableAR)
              Expanded(
                child: _buildInteractiveCard(
                  context,
                  icon: Icons.view_in_ar,
                  title: 'AR Experiences',
                  subtitle: 'Augmented reality',
                  onTap: () => AppRouter.goToAR(context),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureStatusSection(BuildContext context) {
    if (!FeatureFlags.enableDebugMode) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Feature Status',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Enabled Features'),
                    Text(
                      '${FeatureFlags.enabledFeatures.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: FeatureFlags.enabledFeatures.length / FeatureFlags.featureStatus.length,
                  backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 12),
                Text(
                  'Disabled: ${FeatureFlags.disabledFeatures.join(', ')}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 