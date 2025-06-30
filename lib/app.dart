import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buna_app/l10n/app_localizations.dart';
import 'package:buna_app/theme/app_theme.dart';
import 'package:buna_app/providers/locale_provider.dart';
import 'package:buna_app/providers/theme_provider.dart';
import 'package:buna_app/navigation/app_router.dart';
import 'package:buna_app/services/analytics_service.dart';

/// Main app widget with clean router architecture
class BunaApp extends ConsumerWidget {
  const BunaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    
    return MaterialApp.router(
      title: 'Buna Festival',
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
      
      // Router configuration
      routerConfig: AppRouter.router,
      
      // Debug banner
      debugShowCheckedModeBanner: false,
      
      // Builder for analytics
      builder: (context, child) {
        // Track app lifecycle
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AnalyticsService.logEvent(name: 'app_open');
        });
        
        return child!;
      },
    );
  }
}
