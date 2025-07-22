import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../common/language_toggle.dart';

class BunaAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onMenuPressed;

  const BunaAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return AppBar(
      title: Text(title),
      actions: [
        ...?actions,
        IconButton(
          icon: Icon(
            themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          tooltip: 'Toggle theme',
        ),
        const LanguageToggle(),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onMenuPressed ?? () {
            Scaffold.of(context).openEndDrawer();
          },
          tooltip: 'More options',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
