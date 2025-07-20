import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevToolsMenuSheet extends ConsumerWidget {
  final String title;
  final VoidCallback onClose;
  final bool iosSizeMode;
  final VoidCallback toggleIosSizeMode;

  const DevToolsMenuSheet({
    super.key,
    required this.title,
    required this.onClose,
    required this.iosSizeMode,
    required this.toggleIosSizeMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(title),
          trailing: IconButton(icon: Icon(Icons.close), onPressed: onClose),
        ),
        SwitchListTile(
          title: Text('iOS Size Mode'),
          value: iosSizeMode,
          onChanged: (_) => toggleIosSizeMode(),
        ),
        // Add more DevTools options here
      ],
    );
  }
}
