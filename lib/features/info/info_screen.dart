import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/assets.dart';
import '../../config/app_config.dart';
import 'package:buna_app/l10n/app_localizations.dart';

class InfoScreen extends ConsumerWidget {
  const InfoScreen({super.key});

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Festival Banner/Logo
        Center(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  AppAssets.bunaBlack,
                  height: 100,
                  cacheWidth: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.bunaForum,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // About Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Buna Forum is an international decentralized festival supporting the development of the Bulgarian contemporary visual scene and takes place in Varna.',
                ),
                const SizedBox(height: 12),
                const Text(
                  'The 3rd edition of Forum BUNA is realized with the financial support of the Ministry of Culture, the French Institute and the Embassy of France in Bulgaria, the Singer-Zahariev Foundation and in cooperation with the Municipality of Varna.',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Because tidebreakers clash with the waves and change the coast!',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Editions Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _editionButton(
                      context,
                      '2023',
                      'https://bunavarna.com/en/buna-2023/',
                    ),
                    _editionButton(
                      context,
                      '2024',
                      'https://bunavarna.com/en/buna-2024/',
                    ),
                    _editionButton(
                      context,
                      '2025',
                      'https://bunavarna.com/en/buna-2025/',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Contact Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(AppConfig.supportEmail),
                  subtitle: Text(AppLocalizations.of(context)!.emailSupport),
                  onTap: () => _launchUrl('mailto:${AppConfig.supportEmail}'),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(AppConfig.supportPhone),
                  subtitle: Text(AppLocalizations.of(context)!.callSupport),
                  onTap: () => _launchUrl('tel:${AppConfig.supportPhone}'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Social Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Follow Us',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.facebook,
                        color: Color(0xFF4267B2),
                      ),
                      onPressed: () =>
                          _launchUrl('https://www.facebook.com/BunaVarna/'),
                      tooltip: 'Facebook',
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Color(0xFFC13584),
                      ),
                      onPressed: () =>
                          _launchUrl('https://www.instagram.com/buna.varna/'),
                      tooltip: 'Instagram',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Partners Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Partners & Supporters',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ministry of Culture, French Institute, Embassy of France in Bulgaria, Singer-Zahariev Foundation, Municipality of Varna, and others.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _editionButton(BuildContext context, String year, String url) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: Theme.of(context).textTheme.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.open_in_new, size: 18),
      label: Text(year),
      onPressed: () => _launchUrl(url),
    );
  }
}
