import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// BuildContext extensions for easy access to common properties
extension ContextExtensions on BuildContext {
  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Colors
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => colorScheme.surface;
  Color get errorColor => colorScheme.error;

  // Screen size
  Size get size => MediaQuery.of(this).size;
  double get width => size.width;
  double get height => size.height;

  // Screen dimensions helpers
  bool get isSmallScreen => width < 600;
  bool get isMediumScreen => width >= 600 && width < 900;
  bool get isLargeScreen => width >= 900;

  // Padding
  EdgeInsets get padding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;

  // Safe area
  double get topPadding => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  // Keyboard
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  // Brightness
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => theme.brightness == Brightness.light;

  // Spacing shortcuts
  double get xs => AppTheme.xs;
  double get sm => AppTheme.sm;
  double get md => AppTheme.md;
  double get lg => AppTheme.lg;
  double get xl => AppTheme.xl;
  double get xxl => AppTheme.xxl;
}
