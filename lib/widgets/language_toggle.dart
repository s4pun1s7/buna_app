import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buna_app/providers/locale_provider.dart';
import 'package:buna_app/theme/app_theme.dart';

class LanguageToggle extends ConsumerWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isBg = currentLocale.languageCode == 'bg';
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = colorScheme.surface;
    final onSurface = colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: surfaceColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, color: onSurface.withOpacity(0.7), size: 20),
            const SizedBox(width: 8),
            Text(
              'EN',
              style: TextStyle(
                fontWeight: !isBg ? FontWeight.bold : FontWeight.normal,
                color: !isBg ? AppTheme.secondaryColor : onSurface,
              ),
            ),
            Switch(
              value: isBg,
              onChanged: (val) {
                ref.read(localeProvider.notifier).toggleLanguage();
              },
              activeColor: AppTheme.successColor,
              inactiveThumbColor: AppTheme.secondaryColor,
              inactiveTrackColor: AppTheme.secondaryColor.withOpacity(0.2),
            ),
            Text(
              'BG',
              style: TextStyle(
                fontWeight: isBg ? FontWeight.bold : FontWeight.normal,
                color: isBg ? AppTheme.successColor : onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
