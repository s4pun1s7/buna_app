import 'package:flutter/material.dart';

class DevToolsMenuSheet extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  final bool iosSizeMode;
  final VoidCallback toggleIosSizeMode;

  const DevToolsMenuSheet({
    Key? key,
    required this.title,
    required this.onClose,
    required this.iosSizeMode,
    required this.toggleIosSizeMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
