import 'dart:convert';
import 'package:news_nest/core/constants/storage_keys.dart';
import 'package:news_nest/data/models/user_preferences_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Local data source for user preferences using SharedPreferences
class PreferencesLocalSource {
  final SharedPreferences? _prefs;

  PreferencesLocalSource({SharedPreferences? prefs}) : _prefs = prefs;

  Future<SharedPreferences> get _preferences async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  // Save user preferences
  Future<void> savePreferences(UserPreferences preferences) async {
    final prefs = await _preferences;
    await prefs.setString('user_preferences', jsonEncode(preferences.toJson()));
  }

  // Load user preferences
  Future<UserPreferences?> loadPreferences() async {
    final prefs = await _preferences;
    final jsonString = prefs.getString('user_preferences');

    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return UserPreferences.fromJson(json);
  }

  // Mark onboarding as complete
  Future<void> markOnboardingComplete() async {
    final prefs = await _preferences;
    await prefs.setBool(StorageKeys.keyOnboardingComplete, true);
  }

  // Check if onboarding is complete
  Future<bool> isOnboardingComplete() async {
    final prefs = await _preferences;
    return prefs.getBool(StorageKeys.keyOnboardingComplete) ?? false;
  }

  // Save selected interests
  Future<void> saveInterests(List<String> interests) async {
    final prefs = await _preferences;
    await prefs.setStringList(StorageKeys.keySelectedInterests, interests);
  }

  // Load selected interests
  Future<List<String>> loadInterests() async {
    final prefs = await _preferences;
    return prefs.getStringList(StorageKeys.keySelectedInterests) ?? [];
  }

  // Save selected city
  Future<void> saveCity(String city) async {
    final prefs = await _preferences;
    await prefs.setString(StorageKeys.keySelectedCity, city);
  }

  // Load selected city
  Future<String?> loadCity() async {
    final prefs = await _preferences;
    return prefs.getString(StorageKeys.keySelectedCity);
  }

  // Save theme mode
  Future<void> saveThemeMode(String themeMode) async {
    final prefs = await _preferences;
    await prefs.setString(StorageKeys.keyThemeMode, themeMode);
  }

  // Load theme mode
  Future<String> loadThemeMode() async {
    final prefs = await _preferences;
    return prefs.getString(StorageKeys.keyThemeMode) ?? 'system';
  }

  // Save recent searches
  Future<void> saveRecentSearches(List<String> searches) async {
    final prefs = await _preferences;
    await prefs.setStringList(StorageKeys.keyRecentSearches, searches);
  }

  // Load recent searches
  Future<List<String>> loadRecentSearches() async {
    final prefs = await _preferences;
    return prefs.getStringList(StorageKeys.keyRecentSearches) ?? [];
  }

  // Clear all preferences
  Future<void> clearAll() async {
    final prefs = await _preferences;
    await prefs.clear();
  }
}
