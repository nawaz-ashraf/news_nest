import 'package:flutter/material.dart';

// App Color Palette for Light and Dark Modes
class AppColors {
  // Light Theme Colors
  static const Color primaryLight = Color(0xFF1E88E5); // Blue
  static const Color secondaryLight = Color(0xFFFF6B6B); // Coral
  static const Color backgroundLight = Color(0xFFF5F5F5); // Light grey
  static const Color surfaceLight = Color(0xFFFFFFFF); // White
  static const Color errorLight = Color(0xFFE53935); // Red
  static const Color onPrimaryLight = Color(
    0xFFFFFFFF,
  ); // White text on primary
  static const Color onSecondaryLight = Color(
    0xFFFFFFFF,
  ); // White text on secondary
  static const Color onBackgroundLight = Color(0xFF212121); // Dark grey text
  static const Color onSurfaceLight = Color(0xFF212121); // Dark grey text
  static const Color onErrorLight = Color(0xFFFFFFFF); // White text on error

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF64B5F6); // Lighter blue
  static const Color secondaryDark = Color(0xFFFF8A80); // Lighter coral
  static const Color backgroundDark = Color(0xFF121212); // Almost black
  static const Color surfaceDark = Color(0xFF1E1E1E); // Dark grey
  static const Color errorDark = Color(0xFFCF6679); // Lighter red
  static const Color onPrimaryDark = Color(0xFF000000); // Black text on primary
  static const Color onSecondaryDark = Color(
    0xFF000000,
  ); // Black text on secondary
  static const Color onBackgroundDark = Color(0xFFE0E0E0); // Light grey text
  static const Color onSurfaceDark = Color(0xFFE0E0E0); // Light grey text
  static const Color onErrorDark = Color(0xFF000000); // Black text on error

  // Additional Colors
  static const Color accentLight = Color(0xFFFFC107); // Amber
  static const Color accentDark = Color(0xFFFFD54F); // Light amber

  // Neutral Colors (used in both themes)
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
}
