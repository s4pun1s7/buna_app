import 'package:flutter/material.dart';

class FigmaHomeScreen extends StatelessWidget {
  const FigmaHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Figma Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.home, size: 64),
            SizedBox(height: 16),
            Text(
              'Welcome to the Figma Home Screen!',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
