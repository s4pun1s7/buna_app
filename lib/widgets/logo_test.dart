import 'package:flutter/material.dart';
import 'buna_logo.dart';

/// Test widget to verify logo loading
class LogoTest extends StatelessWidget {
  const LogoTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logo Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Testing Logo Assets:'),
            const SizedBox(height: 20),
            
            // Test direct asset loading
            const Text('Direct Asset Test:'),
            Image.asset(
              'assets/Buna blue.png',
              width: 100,
              height: 100,
              cacheWidth: 100,
              cacheHeight: 100,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                  child: const Center(
                    child: Text('ERROR', style: TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // Test BunaLogo widget
            const Text('BunaLogo Widget Test:'),
            const BunaLogo(
              width: 100,
              height: 100,
            ),
            
            const SizedBox(height: 20),
            
            // Test theme switching
            const Text('Current Theme:'),
            Text(
              Theme.of(context).brightness == Brightness.dark ? 'Dark' : 'Light',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            
            const SizedBox(height: 20),
            
            // Test all assets
            const Text('All Assets:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/Buna black.png', width: 50, height: 50, cacheWidth: 50, cacheHeight: 50),
                Image.asset('assets/Buna blue.png', width: 50, height: 50, cacheWidth: 50, cacheHeight: 50),
                Image.asset('assets/Buna pink.png', width: 50, height: 50, cacheWidth: 50, cacheHeight: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 