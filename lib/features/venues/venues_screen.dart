import 'package:flutter/material.dart';

class VenuesScreen extends StatelessWidget {
  const VenuesScreen({super.key});

  Future<void> _simulateLoad() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venues')),
      body: FutureBuilder(
        future: _simulateLoad(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(
            child: Text('Venues list and details coming soon.'),
          );
        },
      ),
    );
  }
}
