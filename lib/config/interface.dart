/// Global interface configuration for the Buna Festival app
/// Centralizes interface constants and settings for consistent design and behavior
class InterfaceConfig {
  // iOS-specific constants
  static const double iosAppBarHeight = 44.0;
  static const double iosBorderRadius = 20.0;
  static const Duration iosAnimation = Duration(milliseconds: 250);
  static const int iosPrimaryColor = 0xFF007AFF; // Example: iOS blue
  static const int iosBackgroundColor = 0xFFF8F8F8;

  // Android-specific constants
  static const double androidAppBarHeight = 56.0;
  static const double androidBorderRadius = 8.0;
  static const Duration androidAnimation = Duration(milliseconds: 200);
  static const int androidPrimaryColor = 0xFF3DDC84; // Example: Android green
  static const int androidBackgroundColor = 0xFFF5F5F5;
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 700);

  // Default paddings and margins
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultBorderRadius = 12.0;

  // Breakpoints for responsive layouts
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  // Accessibility
  static const bool enableHighContrast = false;
  static const bool enableFontScaling = true;

  // Haptic feedback
  static const bool enableHapticFeedback = true;

  // Theme colors (example, use your own palette)
  static const int primaryColor = 0xFF123456;
  static const int accentColor = 0xFF654321;
  static const int backgroundColor = 0xFFF5F5F5;

  // AppBar height
  static const double appBarHeight = 56.0;

  // Shadow elevation
  static const double defaultElevation = 4.0;

  // Font sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;

  // Other UI/UX toggles
  static const bool enableAnimations = true;
  static const bool enableDarkMode = true;
  static const bool enableAccessibility = true;
}
