import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});

  Future<void> _simulateLoad() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Festival Map')),
      body: FutureBuilder(
        future: _simulateLoad(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return const GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(43.2141, 27.9147), // Varna, Bulgaria
              zoom: 13,
            ),
          );
        },
      ),
    );
  }
}
