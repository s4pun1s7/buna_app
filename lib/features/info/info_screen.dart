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
      appBar: AppBar(title: const Text('About Buna Festival')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Forum BUNA', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text(
            'International decentralized festival supporting the Bulgarian contemporary visual scene, held in Varna.',
          ),
          const SizedBox(height: 16),
          Text('Editions', style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed: () =>
                    _launchUrl('https://bunavarna.com/en/buna-2023/'),
                child: const Text('2023'),
              ),
              OutlinedButton(
                onPressed: () =>
                    _launchUrl('https://bunavarna.com/en/buna-2024/'),
                child: const Text('2024'),
              ),
              OutlinedButton(
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
