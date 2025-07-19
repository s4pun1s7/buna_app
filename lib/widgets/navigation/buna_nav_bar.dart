import 'package:flutter/material.dart';
import '../../navigation/route_constants.dart';

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
    final navRoutes = AppRoutes.mainNavRoutes.where((r) => r.isEnabled()).toList();
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: navRoutes
          .map((route) => BottomNavigationBarItem(
                icon: Icon(route.icon, color: iconColor),
                label: route.title,
              ))
          .toList(),
    );
  }
}
