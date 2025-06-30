import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Buna Forum', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text(
            'Buna Forum is an international decentralized festival supporting the development of the Bulgarian contemporary visual scene and takes place in Varna.',
          ),
          const SizedBox(height: 16),
          const Text(
            'The 3rd edition of Forum BUNA is realized with the financial support of the Ministry of Culture, the French Institute and the Embassy of France in Bulgaria, the Singer-Zahariev Foundation and in cooperation with the Municipality of Varna.',
          ),
          const SizedBox(height: 16),
          const Text(
            'Because tidebreakers clash with the waves and change the coast!',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 24),
          Text('Editions', style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: 12, // Increased spacing for consistency
            runSpacing: 12,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                onPressed: () =>
                    _launchUrl('https://bunavarna.com/en/buna-2023/'),
                child: const Text('2023'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                onPressed: () =>
                    _launchUrl('https://bunavarna.com/en/buna-2024/'),
                child: const Text('2024'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                onPressed: () =>
                    _launchUrl('https://bunavarna.com/en/buna-2025/'),
                child: const Text('2025'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Contact', style: Theme.of(context).textTheme.titleMedium),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('forum@bunavarna.com'),
            onTap: () => _launchUrl('mailto:forum@bunavarna.com'),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('088 9044007 (Ralitsa)'),
            onTap: () => _launchUrl('tel:+3590889044007'),
          ),
          const SizedBox(height: 16),
          Text('Follow Us', style: Theme.of(context).textTheme.titleMedium),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.facebook),
                onPressed: () =>
                    _launchUrl('https://www.facebook.com/BunaVarna/'),
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () =>
                    _launchUrl('https://www.instagram.com/buna.varna/'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Partners & Supporters',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Text(
            'Ministry of Culture, French Institute, Embassy of France in Bulgaria, Singer-Zahariev Foundation, Municipality of Varna, and others.',
          ),
        ],
      ),
    );
  }
}
