# 📍 Local News Feature - Agent Instructions

## Feature Overview
The Local News feature displays hyperlocal news filtered by the user's selected city. It provides city-specific updates and events relevant to the user's location.

## Files in This Feature

| File | Purpose |
|------|---------|
| `screens/local_news_screen.dart` | City-specific news feed |
| `widgets/city_header.dart` | City name header widget |

---

## Local News Screen

### Acceptance Criteria
- ✅ Display news filtered by user's selected city
- ✅ Show city header with location icon
- ✅ Pull-to-refresh functionality
- ✅ Infinite scroll (pagination)
- ✅ Show loading, error, and empty states
- ✅ Reuse NewsCard widget from home feature
- ✅ Navigate to article detail on tap
- ✅ Update when user changes city in settings

### Screen Layout
```
┌─────────────────────────────────────┐
│  ← Back    Local News               │
├─────────────────────────────────────┤
│  📍 News from Bangalore              │ ← City Header
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │   News Card                 │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │   News Card                 │   │ ← Pull-to-refresh
│  └─────────────────────────────┘   │   Infinite scroll
│                                     │
└─────────────────────────────────────┘
```

---

## Implementation

### Route Configuration
```dart
// In app_router.dart
GoRoute(
  path: '/local-news',
  name: 'local-news',
  builder: (context, state) => const LocalNewsScreen(),
),
```

### Screen Structure
```dart
class LocalNewsScreen extends StatefulWidget {
  const LocalNewsScreen({super.key});

  @override
  State<LocalNewsScreen> createState() => _LocalNewsScreenState();
}

class _LocalNewsScreenState extends State<LocalNewsScreen> {
  @override
  void initState() {
    super.initState();
    _loadLocalNews();
  }

  Future<void> _loadLocalNews() async {
    final city = context.read<UserPreferencesProvider>().selectedCity;
    await context.read<LocalNewsProvider>().fetchLocalNews(city: city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local News')),
      body: Column(
        children: [
          const CityHeader(),
          Expanded(child: _buildNewsList()),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    return Consumer<LocalNewsProvider>(
      builder: (context, provider, _) {
        // Loading state
        if (provider.isLoading) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (_, __) => const ShimmerCard(),
          );
        }

        // Error state
        if (provider.hasError) {
          return ErrorWidget(
            message: provider.errorMessage,
            onRetry: _loadLocalNews,
          );
        }

        // Empty state
        if (provider.articles.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.location_off,
            message: 'No local news available for your city',
          );
        }

        // Loaded state
        return RefreshIndicator(
          onRefresh: _loadLocalNews,
          child: ListView.builder(
            itemCount: provider.articles.length,
            itemBuilder: (context, index) {
              final article = provider.articles[index];
              return NewsCard(
                article: article,
                onTap: () {
                  context.push('/article/${article.id}', extra: article);
                },
              );
            },
          ),
        );
      },
    );
  }
}
```

---

## City Header Widget

### Purpose
Display the user's selected city with location icon.

### UI Specifications
```
┌────────────────────────────────────┐
│  📍 News from Bangalore            │ ← Location icon + city name
└────────────────────────────────────┘
  Background: Subtle accent color
  Padding: 16dp
```

### Implementation
```dart
class CityHeader extends StatelessWidget {
  const CityHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<UserPreferencesProvider, String?>(
      selector: (_, provider) => provider.selectedCity,
      builder: (context, city, _) {
        if (city == null) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                size: 20,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                'News from $city',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

---

## LocalNewsProvider Implementation

### Provider Structure
```dart
class LocalNewsProvider extends ChangeNotifier {
  final NewsRepository _repository;

  LocalNewsProvider({NewsRepository? repository})
      : _repository = repository ?? NewsRepository();

  // State
  List<Article> _articles = [];
  LoadingState _state = LoadingState.initial;
  String? _errorMessage;
  String? _currentCity;

  // Getters
  List<Article> get articles => List.unmodifiable(_articles);
  LoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == LoadingState.loading;
  bool get hasError => _state == LoadingState.error;

  // Methods
  Future<void> fetchLocalNews({required String? city}) async {
    if (city == null || city.isEmpty) {
      _errorMessage = 'Please select a city in settings';
      _setState(LoadingState.error);
      return;
    }

    _setState(LoadingState.loading);
    _currentCity = city;

    try {
      final result = await _repository.getLocalNews(city: city);
      _articles = result;
      _setState(LoadingState.loaded);
    } catch (e) {
      _errorMessage = 'Failed to load local news';
      _setState(LoadingState.error);
      debugPrint('Local news error: $e');
    }
  }

  void _setState(LoadingState state) {
    _state = state;
    notifyListeners();
  }
}
```

---

## NewsRepository Extension

Add method to fetch local news:

```dart
// In NewsRepository
Future<List<Article>> getLocalNews({required String city}) async {
  // Check cache first
  final cached = await _localSource.getCachedLocalNews(city);
  if (cached != null && !cached.isExpired) {
    return cached.articles;
  }

  // Fetch from API with city filter
  final articles = await _remoteSource.fetchNews(
    city: city,
    category: 'local',
  );

  // Cache the data
  await _localSource.cacheLocalNews(city, articles);

  return articles;
}
```

---

## API Integration

The NewsData.io API supports city/country filtering:

```dart
// In NewsApiService
Future<List<Article>> fetchNews({
  String? category,
  String? city,
  int page = 1,
}) async {
  final params = {
    'apikey': ApiConstants.apiKey,
    'language': 'en',
    'page': page.toString(),
  };

  if (category != null && category != 'All') {
    params['category'] = category.toLowerCase();
  }

  if (city != null) {
    // Map city to query parameter
    params['q'] = city; // Search query
    params['country'] = 'in'; // India
  }

  final response = await _apiClient.get(
    ApiConstants.newsEndpoint,
    params: params,
  );

  final data = response.data;
  final results = data['results'] as List;
  
  return results.map((json) => Article.fromJson(json)).toList();
}
```

---

## Testing Checklist
- [ ] Local news loads for selected city
- [ ] City header displays correct city name
- [ ] Pull-to-refresh works
- [ ] Error state shows when city not selected
- [ ] Empty state shows when no local news available
- [ ] News cards navigate to article detail
- [ ] Updates when user changes city in settings
- [ ] Works in both light and dark mode

---

## Common Pitfalls
- ❌ Don't assume city is always selected
- ❌ Don't forget to handle null city
- ✅ Validate city before API call
- ✅ Show helpful message if city not selected
- ✅ Cache local news separately from general feed
- ✅ Listen to city changes from preferences

---

**Priority**: P0 (Must Have)
**Complexity**: Low-Medium
**Estimated Time**: 2-3 hours
**Dependencies**: 
- LocalNewsProvider
- UserPreferencesProvider
- NewsRepository
- NewsCard widget (from home)
