import 'package:flutter/material.dart';

class BunaDrawer extends StatelessWidget {
  const BunaDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Buna Festival'),
          ),
          ListTile(leading: Icon(Icons.home), title: Text('Home')),
          // Add more navigation items here
        ],
      ),
    );
  }
}
