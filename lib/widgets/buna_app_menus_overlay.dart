import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BunaAppMenusOverlay extends ConsumerWidget {
  final Widget child;
  final bool iosSizeMode;
  final Size iosSize;
  final VoidCallback toggleIosSizeMode;

  const BunaAppMenusOverlay({
    super.key,
    required this.child,
    required this.iosSizeMode,
    required this.iosSize,
    required this.toggleIosSizeMode,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          toolbarHeight: 64,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              // DevTools menu button removed
            ],
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: iosSizeMode
                  ? Container(
                      width: iosSize.width,
                      height: iosSize.height,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: child,
                    )
                  : child,
            ),
            // ...other overlays if needed...
          ],
        ),
      ),
    );
  }
}

class DevToolsMenuSheet extends ConsumerWidget {
  final VoidCallback onClose;
  final bool iosSizeMode;
  final VoidCallback toggleIosSizeMode;
  const DevToolsMenuSheet({
    super.key,
    required this.onClose,
    required this.iosSizeMode,
    required this.toggleIosSizeMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DevTools',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Hot Reload'),
              onTap: () {
                Navigator.of(context).pop();
                // Add hot reload logic if needed
                onClose();
              },
            ),
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('Show Debug Info'),
              onTap: () {
                Navigator.of(context).pop();
                // Add debug info logic if needed
                onClose();
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_iphone),
              title: Text(iosSizeMode ? 'iOS Size: ON' : 'iOS Size: OFF'),
              onTap: () {
                toggleIosSizeMode();
                onClose();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('App Settings'),
              onTap: () {
                Navigator.of(context).pop();
                // Add settings logic if needed
                onClose();
              },
            ),
          ],
        ),
      ),
    );
  }
}
