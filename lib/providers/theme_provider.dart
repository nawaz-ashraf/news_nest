import 'package:flutter/material.dart';
import 'package:news_nest/data/repositories/preferences_repository.dart';

/// ThemeProvider manages the app's theme mode (light/dark/system)
class ThemeProvider extends ChangeNotifier {
  final PreferencesRepository _repository;

  ThemeProvider({PreferencesRepository? repository})
    : _repository = repository ?? PreferencesRepository();

  ThemeMode _themeMode = ThemeMode.system;

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Load saved theme mode from preferences
  Future<void> loadThemeMode() async {
    _themeMode = await _repository.getThemeMode();
    notifyListeners();
  }

  /// Set and persist theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();
    await _repository.saveThemeMode(mode);
  }

  /// Toggle between light and dark (ignores system)
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Get theme mode string for display
  String get themeModeLabel {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}
