// Storage Keys for Hive and SharedPreferences
class StorageKeys {
  // Hive Box Names
  static const String bookmarksBox = 'bookmarks';
  static const String cacheBox = 'news_cache';

  // SharedPreferences Keys
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keySelectedInterests = 'selected_interests';
  static const String keySelectedCity = 'selected_city';
  static const String keyThemeMode = 'theme_mode';
  static const String keyRecentSearches = 'recent_searches';
  static const String keyLastCacheUpdate = 'last_cache_update';

  // Cache Keys (format: category_city_date)
  static String newsCacheKey(String category, String? city) {
    final cityPart = city ?? 'all';
    final date = DateTime.now().toIso8601String().split('T')[0];
    return 'news_${category}_${cityPart}_$date';
  }
}
