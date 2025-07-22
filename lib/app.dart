import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buna_app/l10n/app_localizations.dart';
import 'package:buna_app/theme/app_theme.dart';
import 'package:buna_app/navigation/app_router.dart'; // AR screen removed from router config

class BunaApp extends ConsumerWidget {
  final ThemeMode themeMode;
  final Locale? locale;
  final bool iosSizeMode;
  final Size iosSize;
  final VoidCallback toggleIosSizeMode;

  const BunaApp({
    super.key,
    required this.themeMode,
    required this.locale,
    required this.iosSizeMode,
    required this.iosSize,
    required this.toggleIosSizeMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Buna App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
