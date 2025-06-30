import 'package:flutter/material.dart';

import 'package:buna_app/widgets/error_screen.dart';
import 'package:buna_app/widgets/language_toggle.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = _simulateLoad();
  }

  Future<void> _simulateLoad({bool throwError = false}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (throwError) throw Exception('Failed to load news.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorScreen(
              message: 'Failed to load news.',
              onRetry: () {
                setState(() {
                  _future = _simulateLoad();
                });
              },
            );
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Latest news item - Buna app development
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
                      Row(
                        children: [
                          Icon(
                            Icons.new_releases,
                            color: Colors.orange.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Latest',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.orange.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Today',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Development of the Buna app has begun!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We are excited to announce that development of the official Buna Festival mobile app has started! This app will provide festival-goers with real-time updates, venue information, event schedules, and much more. Stay tuned for more updates as we build the ultimate festival companion app.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_android,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Mobile App',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Additional news items can be added here
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Festival Updates',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'More festival news and updates will be posted here as they become available. Follow us on social media for the latest announcements.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
