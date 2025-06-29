import 'package:flutter/material.dart';

class VenuesScreen extends StatelessWidget {
  const VenuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venues')),
      body: const Center(child: Text('Venues list and details coming soon.')),
    );
  }
}
