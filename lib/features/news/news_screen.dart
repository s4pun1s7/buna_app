import 'package:flutter/material.dart';
import '../../widgets/error_screen.dart';

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
      appBar: AppBar(title: const Text('Festival News')),
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
          return const Center(child: Text('News and updates coming soon.'));
        },
      ),
    );
  }
}
