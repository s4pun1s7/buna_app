import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../navigation/route_constants.dart';

class BunaNavBar extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BunaNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
