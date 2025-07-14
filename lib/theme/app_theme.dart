import 'package:flutter/material.dart';
import 'package:buna_app/theme/theme_light.dart';
import 'package:buna_app/theme/theme_dark.dart';

/// Buna Festival App Theme
///
/// Primary (background): #FF8BA2
/// Secondary: #0144BF (also used for background)
class AppTheme {
  static ThemeData get lightTheme => ThemeLight.themeData;
  static ThemeData get darkTheme => ThemeDark.themeData;
}
