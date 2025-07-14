import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

/// Provider for theme mode
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';

  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  /// Load saved theme preference
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      state = ThemeMode.values[themeIndex];
    } catch (e) {
      // Default to system theme if loading fails
      state = ThemeMode.system;
    }
  }

  /// Save theme preference
  Future<void> _saveTheme(ThemeMode theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, theme.index);
    } catch (e) {
      // Ignore save errors
    }
  }

  /// Set theme mode
  Future<void> setTheme(ThemeMode theme) async {
    state = theme;
    await _saveTheme(theme);
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    ThemeMode newTheme;
    if (state == ThemeMode.light) {
      newTheme = ThemeMode.dark;
    } else if (state == ThemeMode.dark) {
      newTheme = ThemeMode.light;
    } else {
      // If system, default to dark on first toggle
      newTheme = ThemeMode.dark;
    }
    await setTheme(newTheme);
  }

  /// Get current theme data
  ThemeData getThemeData(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return AppTheme.lightTheme;
      case ThemeMode.dark:
        return AppTheme.darkTheme;
      case ThemeMode.system:
        // This will be handled by the app's theme configuration
        return AppTheme.lightTheme;
    }
  }

  /// Check if current theme is dark
  bool get isDarkMode {
    return state == ThemeMode.dark;
  }

  /// Check if current theme is light
  bool get isLightMode {
    return state == ThemeMode.light;
  }
}
