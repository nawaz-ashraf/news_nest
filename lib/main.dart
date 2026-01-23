import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_nest/core/constants/app_constants.dart';
import 'package:news_nest/core/theme/app_theme.dart';
import 'package:news_nest/providers/providers.dart';
import 'package:news_nest/routes/app_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  runApp(const NewsNestApp());
}

class NewsNestApp extends StatelessWidget {
  const NewsNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme Provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadThemeMode()),

        // User Preferences Provider
        ChangeNotifierProvider(
          create: (_) => UserPreferencesProvider()..loadPreferences(),
        ),

        // Onboarding Provider
        ChangeNotifierProvider(
          create: (_) => OnboardingProvider()..checkOnboardingStatus(),
        ),

        // News Feed Provider
        ChangeNotifierProvider(create: (_) => NewsFeedProvider()),

        // Local News Provider
        ChangeNotifierProvider(create: (_) => LocalNewsProvider()),

        // Bookmark Provider
        ChangeNotifierProvider(
          create: (_) => BookmarkProvider()..loadBookmarks(),
        ),

        // Search Provider
        ChangeNotifierProvider(
          create: (_) => SearchProvider()..loadRecentSearches(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,

            // Theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // Router
            routerConfig: AppRouter.instance.router,
          );
        },
      ),
    );
  }
}
