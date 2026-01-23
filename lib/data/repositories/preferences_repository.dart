import 'package:news_nest/data/datasources/local/preferences_local_source.dart';
import 'package:news_nest/data/models/user_preferences_model.dart';
import 'package:flutter/material.dart';

// Preferences Repository
class PreferencesRepository {
  final PreferencesLocalSource _localSource;

  PreferencesRepository({PreferencesLocalSource? localSource})
    : _localSource = localSource ?? PreferencesLocalSource();

  // Save complete preferences
  Future<void> savePreferences(UserPreferences preferences) async {
    await _localSource.savePreferences(preferences);
  }

  // Load preferences
  Future<UserPreferences> loadPreferences() async {
    final prefs = await _localSource.loadPreferences();
    return prefs ?? UserPreferences.initial();
  }

  // Mark onboarding complete
  Future<void> markOnboardingComplete() async {
    await _localSource.markOnboardingComplete();
  }

  // Set onboarding complete status (alias for providers)
  Future<void> setOnboardingComplete(bool complete) async {
    if (complete) {
      await _localSource.markOnboardingComplete();
    }
    // Note: No uncomplete method in local source, would need to add if needed
  }

  // Check onboarding status
  Future<bool> isOnboardingComplete() async {
    return await _localSource.isOnboardingComplete();
  }

  // Save interests
  Future<void> saveInterests(List<String> interests) async {
    await _localSource.saveInterests(interests);
  }

  // Save selected interests (alias for providers)
  Future<void> saveSelectedInterests(List<String> interests) async {
    await _localSource.saveInterests(interests);
  }

  // Load interests
  Future<List<String>> loadInterests() async {
    return await _localSource.loadInterests();
  }

  // Get selected interests (alias for providers)
  Future<List<String>> getSelectedInterests() async {
    return await _localSource.loadInterests();
  }

  // Save city
  Future<void> saveCity(String city) async {
    await _localSource.saveCity(city);
  }

  // Save selected city (alias for providers)
  Future<void> saveSelectedCity(String city) async {
    await _localSource.saveCity(city);
  }

  // Load city
  Future<String?> loadCity() async {
    return await _localSource.loadCity();
  }

  // Get selected city (alias for providers)
  Future<String?> getSelectedCity() async {
    return await _localSource.loadCity();
  }

  // Save theme mode
  Future<void> saveThemeMode(ThemeMode mode) async {
    final modeString = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
        ? 'dark'
        : 'system';
    await _localSource.saveThemeMode(modeString);
  }

  // Load theme mode
  Future<ThemeMode> loadThemeMode() async {
    final modeString = await _localSource.loadThemeMode();
    switch (modeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // Get theme mode (alias for providers)
  Future<ThemeMode> getThemeMode() async {
    return await loadThemeMode();
  }

  // Save recent searches
  Future<void> saveRecentSearches(List<String> searches) async {
    await _localSource.saveRecentSearches(searches);
  }

  // Load recent searches
  Future<List<String>> getRecentSearches() async {
    return await _localSource.loadRecentSearches();
  }

  // Clear all preferences
  Future<void> clearAll() async {
    await _localSource.clearAll();
  }
}
