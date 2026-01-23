// Google AdMob Configuration
class AdMobConstants {
  // ========================================
  // TEST AD UNIT IDs (For Development)
  // ========================================
  static const String testBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const String testNative = 'ca-app-pub-3940256099942544/2247696110';
  static const String testRewarded = 'ca-app-pub-3940256099942544/5224354917';

  // ========================================
  // PRODUCTION AD UNIT IDs (Uncomment when ready)
  // ========================================
  // TODO: Replace with your actual AdMob Ad Unit IDs from Google AdMob Console
  // static const String prodAndroidBanner = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  // static const String prodAndroidInterstitial = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  // static const String prodAndroidNative = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  // static const String prodAndroidRewarded = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

  // ========================================
  // Active Ad Unit IDs (Switch based on build mode)
  // ========================================
  static const bool useTestAds = true; // Set to false for production

  static String get bannerId =>
      useTestAds ? testBanner : testBanner; // Change to prodAndroidBanner
  static String get interstitialId => useTestAds
      ? testInterstitial
      : testInterstitial; // Change to prodAndroidInterstitial
  static String get nativeId =>
      useTestAds ? testNative : testNative; // Change to prodAndroidNative
  static String get rewardedId =>
      useTestAds ? testRewarded : testRewarded; // Change to prodAndroidRewarded

  // ========================================
  // Ad Frequency & Behavior Settings
  // ========================================

  // Banner Ads
  static const bool showBannerOnHome = true;
  static const bool showBannerOnArticle = true;
  static const bool showBannerOnBookmarks = true;
  static const bool showBannerOnSearch = true;

  // Native Ads
  static const int nativeAdInterval = 6; // Show native ad every 6th article
  static const int nativeAdIntervalSearch = 5; // Every 5th search result

  // Interstitial Ads
  static const int maxInterstitialsPerDay = 3;
  static const Duration interstitialCooldown = Duration(seconds: 60);
  static const int articlesBeforeInterstitial =
      3; // Show after reading 3 articles
  static const int appLaunchesBeforeInterstitial =
      2; // Show on 2nd launch of day
  static const Duration noInterstitialGracePeriod = Duration(
    hours: 48,
  ); // No interstitials for new users

  // Rewarded Ads
  static const Duration adFreeRewardDuration = Duration(
    hours: 24,
  ); // 24 hours ad-free after watching

  // ========================================
  // Storage Keys for Ad State
  // ========================================
  static const String keyInterstitialCount = 'interstitial_count_today';
  static const String keyLastInterstitialTime = 'last_interstitial_time';
  static const String keyArticlesReadCount = 'articles_read_count';
  static const String keyFirstLaunchTime = 'first_launch_time';
  static const String keyAdFreeUntil = 'ad_free_until';
  static const String keyTodayDate = 'today_date';
}
