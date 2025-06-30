import 'package:flutter/material.dart';

class BunaNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BunaNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_city),
          label: 'Venues',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
        BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Info'),
      ],
    );
  }
}
