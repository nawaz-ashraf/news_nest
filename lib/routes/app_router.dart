import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_nest/data/models/article_model.dart';
import 'package:news_nest/features/splash/screens/splash_screen.dart';
import 'package:news_nest/features/onboarding/screens/welcome_screen.dart';
import 'package:news_nest/features/onboarding/screens/interest_picker_screen.dart';
import 'package:news_nest/features/onboarding/screens/city_selector_screen.dart';
import 'package:news_nest/features/onboarding/screens/onboarding_complete_screen.dart';
import 'package:news_nest/features/home/screens/home_screen.dart';
import 'package:news_nest/features/article/screens/article_detail_screen.dart';
import 'package:news_nest/features/bookmarks/screens/bookmarks_screen.dart';
import 'package:news_nest/features/search/screens/search_screen.dart';
import 'package:news_nest/features/settings/screens/settings_screen.dart';

/// Route names as constants for type-safe navigation
class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String interests = '/interests';
  static const String city = '/city';
  static const String onboardingComplete = '/onboarding-complete';
  static const String home = '/home';
  static const String article = '/article/:id';
  static const String bookmarks = '/bookmarks';
  static const String search = '/search';
  static const String settings = '/settings';
  static const String localNews = '/local-news';

  // Helper to build article route with ID
  static String articlePath(String id) => '/article/$id';
}

/// App Router configuration using GoRouter
class AppRouter {
  // Private constructor for singleton pattern
  AppRouter._();

  static final AppRouter _instance = AppRouter._();
  static AppRouter get instance => _instance;

  // GoRouter instance
  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: _routes,
    errorBuilder: _errorBuilder,
  );

  // All app routes
  static final List<RouteBase> _routes = [
    // Splash Screen
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // Onboarding Routes
    GoRoute(
      path: AppRoutes.welcome,
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.interests,
      name: 'interests',
      builder: (context, state) => const InterestPickerScreen(),
    ),
    GoRoute(
      path: AppRoutes.city,
      name: 'city',
      builder: (context, state) => const CitySelectorScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboardingComplete,
      name: 'onboarding-complete',
      builder: (context, state) => const OnboardingCompleteScreen(),
    ),

    // Main App Routes
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    // Article Detail
    GoRoute(
      path: AppRoutes.article,
      name: 'article-detail',
      builder: (context, state) {
        final articleId = state.pathParameters['id'];
        final article = state.extra as Article?;

        // If article not passed via extra, show error
        if (article == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Article Not Found')),
            body: Center(child: Text('Article ID: $articleId not available')),
          );
        }

        return ArticleDetailScreen(article: article);
      },
    ),

    // Bookmarks
    GoRoute(
      path: AppRoutes.bookmarks,
      name: 'bookmarks',
      builder: (context, state) => const BookmarksScreen(),
    ),

    // Search
    GoRoute(
      path: AppRoutes.search,
      name: 'search',
      builder: (context, state) => const SearchScreen(),
    ),

    // Settings
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    // Local News
    GoRoute(
      path: AppRoutes.localNews,
      name: 'local-news',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Local News'),
      // TODO: Replace with actual LocalNewsScreen
    ),
  ];

  // Error page for unknown routes
  static Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder screen for routes during development
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              '$title Screen',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon...',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extension on BuildContext for easier navigation
extension NavigationExtension on BuildContext {
  /// Navigate to home
  void goHome() => go(AppRoutes.home);

  /// Navigate to article detail
  void goToArticle(Article article) {
    push(AppRoutes.articlePath(article.id), extra: article);
  }

  /// Navigate to bookmarks
  void goToBookmarks() => push(AppRoutes.bookmarks);

  /// Navigate to search
  void goToSearch() => push(AppRoutes.search);

  /// Navigate to settings
  void goToSettings() => push(AppRoutes.settings);

  /// Start onboarding
  void startOnboarding() => go(AppRoutes.welcome);
}
