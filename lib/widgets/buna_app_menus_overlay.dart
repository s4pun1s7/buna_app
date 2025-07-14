import 'package:flutter/material.dart';

class BunaAppMenusOverlay extends StatefulWidget {
  final Widget child;
  final bool iosSizeMode;
  final Size iosSize;
  final VoidCallback toggleIosSizeMode;

  const BunaAppMenusOverlay({
    Key? key,
    required this.child,
    required this.iosSizeMode,
    required this.iosSize,
    required this.toggleIosSizeMode,
  }) : super(key: key);

  @override
  State<BunaAppMenusOverlay> createState() => _BunaAppMenusOverlayState();
}

class _BunaAppMenusOverlayState extends State<BunaAppMenusOverlay> {
  void _openMenu(String menu) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        if (menu == 'devtools') {
          return DevToolsMenuSheet(
            onClose: () => Navigator.of(context).pop(),
            iosSizeMode: widget.iosSizeMode,
            toggleIosSizeMode: widget.toggleIosSizeMode,
          );
        }
        // Add more menus here
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              IconButton(
                icon: const Icon(Icons.menu, size: 32),
                tooltip: 'DevTools Menu',
                onPressed: () => _openMenu('devtools'),
              ),
              // Add more top bar buttons here if needed
            ],
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: widget.iosSizeMode
                  ? Container(
                      width: widget.iosSize.width,
                      height: widget.iosSize.height,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: widget.child,
                    )
                  : widget.child,
            ),
            // ...other overlays if needed...
          ],
        ),
      ),
    );
  }
}

class DevToolsMenuSheet extends StatelessWidget {
  final VoidCallback onClose;
  final bool iosSizeMode;
  final VoidCallback toggleIosSizeMode;
  const DevToolsMenuSheet({
    Key? key,
    required this.onClose,
    required this.iosSizeMode,
    required this.toggleIosSizeMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DevTools',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
