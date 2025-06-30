import 'package:flutter/material.dart';

/// Buna Festival App Theme
///
/// Primary (background): #FF8BA2
/// Secondary: #0144BF (also used for background)
class AppTheme {
  static const Color primaryColor = Color(0xFFFF8BA2);
  static const Color secondaryColor = Color(0xFF0144BF);
  static const Color accentColor = Color(0xFFFF6B9D);
  static const Color surfaceColor = Color(0xFFF8F9FA);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color successColor = Color(0xFF27AE60);
  static const Color warningColor = Color(0xFFF39C12);

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: Colors.white,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: surfaceColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondaryColor,
          backgroundColor: Colors.white,
          side: const BorderSide(color: secondaryColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondaryColor,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: secondaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: secondaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade100,
        selectedColor: secondaryColor,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      fontFamily: 'Roboto',
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: const Color(0xFF1E1E1E),
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondaryColor,
          side: const BorderSide(color: secondaryColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: const Color(0xFF1E1E1E),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: secondaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: secondaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2A2A2A),
        selectedColor: secondaryColor,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        secondaryLabelStyle: const TextStyle(color: Colors.black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      fontFamily: 'Roboto',
      useMaterial3: true,
    );
  }
}
