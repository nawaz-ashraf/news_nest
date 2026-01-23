# 🤖 NewsNest AI Agent Instructions

## Document Purpose
This is the **master instruction file** for AI agents working on the NewsNest project. It provides architectural guidelines, coding standards, and development patterns that all agents must follow.

> **⚠️ IMPORTANT**: Always read the feature-specific `AGENT.md` file in each feature folder before implementing. Feature-specific instructions **override** these generic patterns.

---

## 📋 Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture Guidelines](#2-architecture-guidelines)
3. [Folder Structure](#3-folder-structure)
4. [Coding Standards](#4-coding-standards)
5. [State Management (Provider)](#5-state-management-provider)
6. [API Integration](#6-api-integration)
7. [UI/UX Guidelines](#7-uiux-guidelines)
8. [Testing Guidelines](#8-testing-guidelines)
9. [Feature Implementation Checklist](#9-feature-implementation-checklist)
10. [Common Patterns](#10-common-patterns)
11. [Do's and Don'ts](#11-dos-and-donts)

---

## 1. Project Overview

### 1.1 What is NewsNest?
NewsNest is a **personalized news aggregator app** for Indian users featuring:
- Pinterest-style interest selection
- Hyperlocal news (Delhi NCR, Bangalore, Hyderabad, Kolkata, etc.)
- Provider-based state management
- Modern, clean UI with smooth animations

### 1.2 Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter 3.16+ |
| State Management | Provider 6.x |
| Networking | Dio |
| Local Storage | Hive + SharedPreferences |
| Navigation | GoRouter |
| UI Components | Material 3 + Custom Widgets |
| Animations | flutter_animate + Lottie |
| API | NewsData.io |

### 1.3 Target Platform
- **Primary**: Android
- **Minimum SDK**: 21 (Android 5.0)
- **Target SDK**: 34 (Android 14)

---

## 2. Architecture Guidelines

### 2.1 Architecture Pattern
We follow a **simplified Clean Architecture** with Provider:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌─────────────────────────────────────────────────────────┐│
│  │  Screens (Pages) → Widgets → Providers                  ││
│  └─────────────────────────────────────────────────────────┘│
├─────────────────────────────────────────────────────────────┤
│                      DATA LAYER                              │
│  ┌─────────────────────────────────────────────────────────┐│
│  │  Repositories → Data Sources (Remote/Local) → Models   ││
│  └─────────────────────────────────────────────────────────┘│
├─────────────────────────────────────────────────────────────┤
│                      CORE LAYER                              │
│  ┌─────────────────────────────────────────────────────────┐│
│  │  Constants, Theme, Utils, Network, Extensions           ││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Layer Responsibilities

| Layer | Responsibility | Can Depend On |
|-------|---------------|---------------|
| **Presentation** | UI, user interaction, state | Data, Core |
| **Data** | Data fetching, caching, models | Core |
| **Core** | Shared utilities, constants, theme | Nothing |

### 2.3 Data Flow

```
User Action → Screen → Provider → Repository → DataSource → API/Cache
                ↑                                    │
                └────────────────────────────────────┘
                        (notifyListeners)
```

---

## 3. Folder Structure

```
lib/
├── main.dart                      # App entry point
├── app.dart                       # MaterialApp configuration
│
├── core/                          # Shared utilities & config
│   ├── constants/
│   │   ├── api_constants.dart     # API URLs, keys
│   │   ├── app_constants.dart     # App-wide constants
│   │   ├── storage_keys.dart      # Hive/SharedPrefs keys
│   │   ├── categories.dart        # News categories enum
│   │   └── cities.dart            # Supported cities
│   ├── theme/
│   │   ├── app_theme.dart         # Light/Dark themes
│   │   ├── app_colors.dart        # Color palette
│   │   └── app_text_styles.dart   # Typography
│   ├── network/
│   │   ├── api_client.dart        # Dio setup
│   │   ├── api_exceptions.dart    # Custom exceptions
│   │   └── network_info.dart      # Connectivity check
│   ├── utils/
│   │   ├── date_utils.dart        # Date formatting
│   │   ├── validators.dart        # Input validation
│   │   └── helpers.dart           # General helpers
│   └── extensions/
│       ├── context_extensions.dart
│       ├── string_extensions.dart
│       └── date_extensions.dart
│
├── data/
│   ├── models/
│   │   ├── article_model.dart
│   │   ├── category_model.dart
│   │   └── user_preferences_model.dart
│   ├── repositories/
│   │   ├── news_repository.dart
│   │   ├── preferences_repository.dart
│   │   └── bookmark_repository.dart
│   └── datasources/
│       ├── remote/
│       │   └── news_api_service.dart
│       └── local/
│           ├── preferences_local_source.dart
│           └── bookmark_local_source.dart
│
├── providers/
│   ├── theme_provider.dart
│   ├── user_preferences_provider.dart
│   ├── news_feed_provider.dart
│   ├── local_news_provider.dart
│   ├── bookmark_provider.dart
│   └── onboarding_provider.dart
│
├── features/                      # Feature modules
│   ├── splash/
│   │   ├── AGENT.md              # Feature-specific instructions
│   │   └── screens/
│   │       └── splash_screen.dart
│   ├── onboarding/
│   │   ├── AGENT.md
│   │   ├── screens/
│   │   │   ├── welcome_screen.dart
│   │   │   ├── interest_picker_screen.dart
│   │   │   ├── city_selector_screen.dart
│   │   │   └── onboarding_complete_screen.dart
│   │   └── widgets/
│   │       ├── interest_tile.dart
│   │       ├── city_tile.dart
│   │       └── welcome_slide.dart
│   ├── home/
│   │   ├── AGENT.md
│   │   ├── screens/
│   │   │   └── home_screen.dart
│   │   └── widgets/
│   │       ├── news_card.dart
│   │       ├── news_card_compact.dart
│   │       ├── category_tabs.dart
│   │       └── shimmer_card.dart
│   ├── article/
│   │   ├── AGENT.md
│   │   ├── screens/
│   │   │   └── article_detail_screen.dart
│   │   └── widgets/
│   │       └── related_articles.dart
│   ├── local_news/
│   │   ├── AGENT.md
│   │   ├── screens/
│   │   │   └── local_news_screen.dart
│   │   └── widgets/
│   │       └── city_header.dart
│   ├── bookmarks/
│   │   ├── AGENT.md
│   │   ├── screens/
│   │   │   └── bookmarks_screen.dart
│   │   └── widgets/
│   │       └── bookmark_card.dart
│   ├── search/
│   │   ├── AGENT.md
│   │   ├── screens/
│   │   │   └── search_screen.dart
│   │   └── widgets/
│   │       └── search_result_card.dart
│   └── settings/
│       ├── AGENT.md
│       ├── screens/
│       │   └── settings_screen.dart
│       └── widgets/
│           └── settings_tile.dart
│
├── shared/                        # Shared widgets
│   └── widgets/
│       ├── custom_app_bar.dart
│       ├── loading_widget.dart
│       ├── error_widget.dart
│       ├── empty_state_widget.dart
│       └── primary_button.dart
│
└── routes/
    └── app_router.dart            # GoRouter configuration
```

---

## 4. Coding Standards

### 4.1 Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | snake_case | `news_card.dart` |
| Classes | PascalCase | `NewsCardWidget` |
| Variables | camelCase | `articleList` |
| Constants | camelCase or SCREAMING_SNAKE | `apiBaseUrl` or `API_BASE_URL` |
| Private | prefix with _ | `_isLoading` |
| Providers | suffix with Provider | `NewsFeedProvider` |

### 4.2 File Organization

Every Dart file should follow this order:
```dart
// 1. Imports (sorted)
import 'dart:async';                    // Dart SDK
import 'package:flutter/material.dart'; // Flutter
import 'package:provider/provider.dart'; // Packages
import '../models/article.dart';        // Project imports

// 2. Part directives (if any)
part 'article_model.g.dart';

// 3. Constants (file-level)
const double _kCardHeight = 120.0;

// 4. Main class/widget
class ArticleCard extends StatelessWidget {
  // ...
}

// 5. Supporting classes (private)
class _ArticleCardState extends State<ArticleCard> {
  // ...
}
```

### 4.3 Widget Guidelines

```dart
class NewsCard extends StatelessWidget {
  // 1. Constructor at top with key
  const NewsCard({
    super.key,
    required this.article,
    this.onTap,
    this.onBookmark,
  });

  // 2. Final fields
  final Article article;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;

  // 3. Build method
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _buildCard(context),
    );
  }

  // 4. Private helper methods
  Widget _buildCard(BuildContext context) {
    // ...
  }
}
```

### 4.4 Provider Guidelines

```dart
class NewsFeedProvider extends ChangeNotifier {
  // 1. Dependencies (injected via constructor)
  final NewsRepository _repository;

  NewsFeedProvider({NewsRepository? repository})
      : _repository = repository ?? NewsRepository();

  // 2. Private state variables
  List<Article> _articles = [];
  LoadingState _state = LoadingState.initial;
  String? _errorMessage;

  // 3. Public getters (no setters for state)
  List<Article> get articles => List.unmodifiable(_articles);
  LoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == LoadingState.loading;
  bool get hasError => _state == LoadingState.error;

  // 4. Public methods (business logic)
  Future<void> fetchNews({bool refresh = false}) async {
    _setState(LoadingState.loading);
    
    try {
      final result = await _repository.getNews();
      _articles = result;
      _setState(LoadingState.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(LoadingState.error);
    }
  }

  // 5. Private helper methods
  void _setState(LoadingState state) {
    _state = state;
    notifyListeners();
  }
}
```

---

## 5. State Management (Provider)

### 5.1 Provider Types to Use

| Provider Type | When to Use |
|---------------|-------------|
| `ChangeNotifierProvider` | Main state containers (NewsFeed, Bookmarks) |
| `Provider` | Static/rarely changing data |
| `ProxyProvider` | When one provider depends on another |
| `FutureProvider` | One-time async data fetch |
| `Consumer` | Rebuild specific widgets |
| `Selector` | Optimized rebuilds (specific field changes) |

### 5.2 State Enum

Always use this enum for loading states:
```dart
enum LoadingState {
  initial,    // Not yet loaded
  loading,    // Currently fetching
  loaded,     // Successfully loaded
  error,      // Error occurred
  loadingMore // Loading pagination
}
```

### 5.3 Provider Registration

In `main.dart`:
```dart
MultiProvider(
  providers: [
    // Independent providers first
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => UserPreferencesProvider()),
    ChangeNotifierProvider(create: (_) => BookmarkProvider()),
    
    // Dependent providers use ProxyProvider
    ChangeNotifierProxyProvider<UserPreferencesProvider, NewsFeedProvider>(
      create: (_) => NewsFeedProvider(),
      update: (_, prefs, feed) => feed!..updatePreferences(prefs),
    ),
  ],
  child: const MyApp(),
)
```

### 5.4 Consuming Providers in Widgets

```dart
// ❌ DON'T: Rebuild entire widget
Widget build(BuildContext context) {
  final provider = Provider.of<NewsFeedProvider>(context);
  return Text(provider.articles.length.toString());
}

// ✅ DO: Use Consumer for targeted rebuilds
Widget build(BuildContext context) {
  return Consumer<NewsFeedProvider>(
    builder: (context, provider, child) {
      return Text(provider.articles.length.toString());
    },
  );
}

// ✅ BETTER: Use Selector for specific field
Widget build(BuildContext context) {
  return Selector<NewsFeedProvider, int>(
    selector: (_, provider) => provider.articles.length,
    builder: (context, count, child) {
      return Text(count.toString());
    },
  );
}

// ✅ BEST: Use read() for one-time access (in callbacks)
void _onRefresh() {
  context.read<NewsFeedProvider>().fetchNews(refresh: true);
}
```

---

## 6. API Integration

### 6.1 API Configuration

```dart
// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://newsdata.io/api/1';
  static const String apiKey = 'YOUR_API_KEY'; // Use env in production
  
  static const String newsEndpoint = '/news';
  
  static const Duration timeout = Duration(seconds: 30);
  static const int maxRetries = 3;
}
```

### 6.2 Dio Setup

```dart
// lib/core/network/api_client.dart
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.timeout,
      receiveTimeout: ApiConstants.timeout,
      queryParameters: {'apikey': ApiConstants.apiKey},
    ));

    _dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      RetryInterceptor(dio: _dio, retries: ApiConstants.maxRetries),
    ]);
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    try {
      return await _dio.get(path, queryParameters: params);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    // Map DioException to custom ApiException
  }
}
```

### 6.3 Repository Pattern

```dart
// lib/data/repositories/news_repository.dart
class NewsRepository {
  final NewsApiService _remoteSource;
  final NewsLocalSource _localSource;

  NewsRepository({
    NewsApiService? remoteSource,
    NewsLocalSource? localSource,
  })  : _remoteSource = remoteSource ?? NewsApiService(),
        _localSource = localSource ?? NewsLocalSource();

  Future<List<Article>> getNews({
    required String category,
    int page = 1,
  }) async {
    // 1. Try cache first
    final cached = await _localSource.getCachedNews(category);
    if (cached != null && !cached.isExpired) {
      return cached.articles;
    }

    // 2. Fetch from API
    final articles = await _remoteSource.fetchNews(
      category: category,
      page: page,
    );

    // 3. Update cache
    await _localSource.cacheNews(category, articles);

    return articles;
  }
}
```

### 6.4 Caching Strategy

```
CACHE DURATION: 4 hours per category
CACHE KEY FORMAT: news_{category}_{city}_{date}

ON FETCH:
1. Check cache → if valid, return cached
2. If expired/missing → fetch from API
3. On success → update cache
4. On error → return stale cache if available

ON REFRESH (Pull-to-Refresh):
1. Force fetch from API (ignore cache)
2. Update cache on success
```

---

## 7. UI/UX Guidelines

### 7.1 Design System

```dart
// Colors (from app_colors.dart)
primary: Color(0xFF1E88E5)      // Blue
secondary: Color(0xFFFF6B6B)    // Coral
background: Color(0xFFF5F5F5)   // Light grey
surface: Color(0xFFFFFFFF)      // White
error: Color(0xFFE53935)        // Red

// Dark Mode
primaryDark: Color(0xFF64B5F6)
backgroundDark: Color(0xFF121212)
surfaceDark: Color(0xFF1E1E1E)
```

### 7.2 Spacing System

Always use multiples of 4:
```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
```

### 7.3 Border Radius

```dart
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 999.0; // Pill shape
}
```

### 7.4 Animation Guidelines

| Interaction | Duration | Curve |
|-------------|----------|-------|
| Tap feedback | 100ms | easeOut |
| Page transition | 300ms | easeInOut |
| Loading shimmer | 1500ms | linear (loop) |
| Button state | 200ms | easeInOut |
| Card appear | 400ms | easeOutCubic |

### 7.5 Required States for Every Screen

1. **Loading State**: Shimmer skeleton matching layout
2. **Error State**: Friendly message + retry button
3. **Empty State**: Illustration + helpful message + CTA
4. **Loaded State**: Actual content

---

## 8. Testing Guidelines

### 8.1 Test File Structure

```
test/
├── unit/
│   ├── providers/
│   │   └── news_feed_provider_test.dart
│   └── repositories/
│       └── news_repository_test.dart
├── widget/
│   ├── screens/
│   │   └── home_screen_test.dart
│   └── widgets/
│       └── news_card_test.dart
└── integration/
    └── app_test.dart
```

### 8.2 Test Naming

```dart
// Format: should_expectedBehavior_when_condition
test('should return articles when API call succeeds', () async {
  // ...
});

test('should show error widget when loading fails', () async {
  // ...
});
```

### 8.3 Provider Testing

```dart
void main() {
  late NewsFeedProvider provider;
  late MockNewsRepository mockRepository;

  setUp(() {
    mockRepository = MockNewsRepository();
    provider = NewsFeedProvider(repository: mockRepository);
  });

  test('should update state to loading when fetching', () async {
    when(mockRepository.getNews(any)).thenAnswer(
      (_) async => [testArticle],
    );

    final future = provider.fetchNews();
    
    expect(provider.state, LoadingState.loading);
    
    await future;
    
    expect(provider.state, LoadingState.loaded);
    expect(provider.articles, [testArticle]);
  });
}
```

---

## 9. Feature Implementation Checklist

When implementing any feature, ensure:

### Planning
- [ ] Read the feature's `AGENT.md` file
- [ ] Understand all acceptance criteria
- [ ] Identify dependencies on other features

### Implementation
- [ ] Create folder structure per pattern
- [ ] Implement models (if new data)
- [ ] Implement repository methods (if data needed)
- [ ] Create provider with proper state management
- [ ] Build screen with all states (loading, error, empty, loaded)
- [ ] Create reusable widgets

### Quality
- [ ] No hardcoded strings (use constants)
- [ ] No hardcoded colors (use theme)
- [ ] Responsive design (test on multiple sizes)
- [ ] Handle all edge cases
- [ ] Add error handling
- [ ] Write at least 1 test

### Review
- [ ] Code follows naming conventions
- [ ] No unused imports
- [ ] No `print()` statements (use logging)
- [ ] Provider properly disposes resources
- [ ] UI matches specification

---

## 10. Common Patterns

### 10.1 Loading + Error + Content Pattern

```dart
Widget build(BuildContext context) {
  return Consumer<NewsFeedProvider>(
    builder: (context, provider, _) {
      if (provider.isLoading) {
        return const LoadingWidget();
      }
      
      if (provider.hasError) {
        return ErrorWidget(
          message: provider.errorMessage,
          onRetry: () => provider.fetchNews(),
        );
      }
      
      if (provider.articles.isEmpty) {
        return const EmptyStateWidget(
          message: 'No articles found',
        );
      }
      
      return ListView.builder(
        itemCount: provider.articles.length,
        itemBuilder: (context, index) {
          return NewsCard(article: provider.articles[index]);
        },
      );
    },
  );
}
```

### 10.2 Pull-to-Refresh Pattern

```dart
RefreshIndicator(
  onRefresh: () async {
    await context.read<NewsFeedProvider>().fetchNews(refresh: true);
  },
  child: ListView.builder(...),
)
```

### 10.3 Infinite Scroll Pattern

```dart
NotificationListener<ScrollNotification>(
  onNotification: (notification) {
    if (notification is ScrollEndNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels >= metrics.maxScrollExtent * 0.8) {
        context.read<NewsFeedProvider>().loadMore();
      }
    }
    return false;
  },
  child: ListView.builder(...),
)
```

### 10.4 Safe Async Pattern

```dart
Future<void> _loadData() async {
  if (!mounted) return; // Check if widget is still mounted
  
  await provider.fetchData();
  
  if (!mounted) return; // Check again after async operation
  
  // Safe to update UI
}
```

---

## 11. Do's and Don'ts

### ✅ DO

- Use `const` constructors wherever possible
- Use `context.read()` in callbacks, `context.watch()` in build
- Handle all loading states
- Use meaningful variable names
- Keep widgets small and focused
- Cache images with `CachedNetworkImage`
- Use `ListView.builder` for long lists

### ❌ DON'T

- Don't use `setState` in widgets using Provider
- Don't call `notifyListeners()` in constructor
- Don't store `BuildContext` in providers
- Don't make synchronous I/O operations
- Don't use `print()` for debugging (use `debugPrint`)
- Don't hardcode colors, strings, or dimensions
- Don't create providers inside widgets

---

## 📎 Related Documents

| Document | Location | Purpose |
|----------|----------|---------|
| PRD | `docs/PRD.md` | Full product requirements |
| Feature Agent Files | `lib/features/*/AGENT.md` | Feature-specific instructions |
| API Docs | `docs/API.md` | API integration details |
| Design System | `docs/DESIGN.md` | UI/UX specifications |

---

## 🔄 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-23 | Initial document |

---

> **Remember**: When in doubt, check the feature-specific `AGENT.md` file. It contains the most relevant and up-to-date instructions for each feature.
