// Application-wide Constants
class AppConstants {
  // App Info
  static const String appName = 'NewsNest';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Your personalized news companion';

  // Onboarding
  static const int minInterests = 3;
  static const int maxInterests = 15;

  // Pagination
  static const int newsPageSize = 20;
  static const double infiniteScrollThreshold = 0.8; // 80% scroll to load more

  // Cache
  static const int maxCachedArticles = 100;
  static const int maxRecentSearches = 10;

  // UI
  static const int maxTitleLines = 3;
  static const int maxDescriptionLines = 5;

  // Debouncing
  static const Duration searchDebounce = Duration(milliseconds: 500);

  // Animation
  static const Duration splashDuration = Duration(milliseconds: 2500);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // URLs
  static const String privacyPolicyUrl = 'https://newsnest.com/privacy';
  static const String termsOfServiceUrl = 'https://newsnest.com/terms';
  static const String supportEmail = 'support@newsnest.com';
}
