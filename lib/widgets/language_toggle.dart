import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buna_app/providers/locale_provider.dart';

class LanguageToggle extends ConsumerWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
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
            Icon(Icons.language, color: Colors.blueGrey.shade700, size: 20),
            const SizedBox(width: 8),
            Text(
              'EN',
              style: TextStyle(
                fontWeight: currentLocale.languageCode == 'en'
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: currentLocale.languageCode == 'en'
                    ? Colors.blue
                    : Colors.black,
              ),
            ),
            Switch(
              value: currentLocale.languageCode == 'bg',
              onChanged: (val) {
                ref.read(localeProvider.notifier).toggleLanguage();
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.blue,
              inactiveTrackColor: Colors.blue.shade100,
            ),
            Text(
              'BG',
              style: TextStyle(
                fontWeight: currentLocale.languageCode == 'bg'
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: currentLocale.languageCode == 'bg'
                    ? Colors.green
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
