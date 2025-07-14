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
    final iconColor = Theme.of(context).iconTheme.color;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: iconColor),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_city, color: iconColor),
          label: 'Venues',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map, color: iconColor),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article, color: iconColor),
          label: 'News',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info_outline, color: iconColor),
          label: 'Info',
        ),
      ],
    );
  }
}
