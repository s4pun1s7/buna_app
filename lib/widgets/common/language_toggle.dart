import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buna_app/providers/locale_provider.dart';

class LanguageToggle extends ConsumerWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return PopupMenuButton<Locale>(
      icon: Icon(
        Icons.language,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      tooltip: 'Change language',
      onSelected: (locale) {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Row(
            children: [
              Icon(
                Icons.check,
                color: currentLocale.languageCode == 'en'
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text('English'),
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('bg'),
          child: Row(
            children: [
              Icon(
                Icons.check,
                color: currentLocale.languageCode == 'bg'
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text('Български'),
            ],
          ),
        ),
      ],
    );
  }
}
