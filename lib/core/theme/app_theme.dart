import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

// App Theme Configuration
class AppTheme {
  // Spacing constants (multiples of 4)
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Border radius constants
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        surface: AppColors.surfaceLight,
        error: AppColors.errorLight,
        onPrimary: AppColors.onPrimaryLight,
        onSecondary: AppColors.onSecondaryLight,
        onSurface: AppColors.onSurfaceLight,
        onError: AppColors.onErrorLight,
      ),

      scaffoldBackgroundColor: AppColors.backgroundLight,

      // Typography
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.onPrimaryLight,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: AppColors.onPrimaryLight,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        color: AppColors.surfaceLight,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: md, vertical: md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: md, vertical: sm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.errorLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: md,
          vertical: md,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey200,
        selectedColor: AppColors.primaryLight,
        labelStyle: AppTextStyles.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: sm, vertical: xs),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.secondaryDark,
        surface: AppColors.surfaceDark,
        error: AppColors.errorDark,
        onPrimary: AppColors.onPrimaryDark,
        onSecondary: AppColors.onSecondaryDark,
        onSurface: AppColors.onSurfaceDark,
        onError: AppColors.onErrorDark,
      ),

      scaffoldBackgroundColor: AppColors.backgroundDark,

      // Typography
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: AppColors.onBackgroundDark,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: AppColors.onBackgroundDark,
        ),
        displaySmall: AppTextStyles.displaySmall.copyWith(
          color: AppColors.onBackgroundDark,
        ),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.onBackgroundDark,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.onBackgroundDark,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.onBackgroundDark,
        ),
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: AppColors.onBackgroundDark,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: AppColors.onBackgroundDark,
        ),
        titleSmall: AppTextStyles.titleSmall.copyWith(
          color: AppColors.onBackgroundDark,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.onBackgroundDark,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.onBackgroundDark,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.onBackgroundDark,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: AppColors.onBackgroundDark,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: AppColors.onBackgroundDark,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: AppColors.onBackgroundDark,
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.onSurfaceDark,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: AppColors.onSurfaceDark,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        color: AppColors.surfaceDark,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: md, vertical: md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: md, vertical: sm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.errorDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: md,
          vertical: md,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey800,
        selectedColor: AppColors.primaryDark,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.onSurfaceDark,
        ),
        padding: const EdgeInsets.symmetric(horizontal: sm, vertical: xs),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
      ),
    );
  }
}
