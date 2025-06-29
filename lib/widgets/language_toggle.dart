import 'package:flutter/material.dart';

class LanguageToggle extends StatelessWidget {
  final Locale currentLocale;
  final void Function(Locale) onLocaleChanged;
  const LanguageToggle({super.key, required this.currentLocale, required this.onLocaleChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(left: 16, bottom: 32), // was 80, now 32 to match new placement
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
            Text('EN', style: TextStyle(
              fontWeight: currentLocale.languageCode == 'en' ? FontWeight.bold : FontWeight.normal,
              color: currentLocale.languageCode == 'en' ? Colors.blue : Colors.black,
            )),
            Switch(
              value: currentLocale.languageCode == 'bg',
              onChanged: (val) {
                onLocaleChanged(Locale(val ? 'bg' : 'en'));
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.blue,
              inactiveTrackColor: Colors.blue.shade100,
            ),
            Text('BG', style: TextStyle(
              fontWeight: currentLocale.languageCode == 'bg' ? FontWeight.bold : FontWeight.normal,
              color: currentLocale.languageCode == 'bg' ? Colors.green : Colors.black,
            )),
          ],
        ),
      ),
    );
  }
}
