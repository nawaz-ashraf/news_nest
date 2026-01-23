# 🔍 Search Feature - Agent Instructions

## Feature Overview
The Search feature allows users to search for news articles by keywords, with real-time results, recent searches history, and search suggestions.

## Files in This Feature

| File | Purpose |
|------|---------|
| `screens/search_screen.dart` | Search interface and results |
| `widgets/search_result_card.dart` | Search result list item |

---

## Search Screen

### Acceptance Criteria
- ✅ Search input field with clear button
- ✅ Real-time search (debounced)
- ✅ Show recent searches before query
- ✅ Display search results as list
- ✅ Show loading state during search
- ✅ Show empty state if no results
- ✅ Tap result to open article detail
- ✅ Save search queries to history
- ✅ Clear search history option

### Screen Layout
```
┌─────────────────────────────────────┐
│  ← [Search input...........] [X]    │ ← Search bar
├─────────────────────────────────────┤
│                                     │
│  Recent Searches                    │ ← Before typing
│  • Technology news                  │
│  • COVID updates                    │
│  • IPL cricket                      │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  Results for "technology"           │ ← After search
│                                     │
│  ┌─────────────────────────────┐   │
│  │   Search Result Card        │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## Implementation

### Route Configuration
```dart
// In app_router.dart
GoRoute(
  path: '/search',
  name: 'search',
  builder: (context, state) => const SearchScreen(),
),
```

### Screen Structure
```dart
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    
    // Load recent searches
    context.read<SearchProvider>().loadRecentSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    // Debounce search to avoid API spam
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        context.read<SearchProvider>().search(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search news...',
          border: InputBorder.none,
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<SearchProvider>().clearResults();
                  },
                )
              : null,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (query) {
          if (query.isNotEmpty) {
            context.read<SearchProvider>().search(query);
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<SearchProvider>(
      builder: (context, provider, _) {
        // Show recent searches if no query
        if (_searchController.text.isEmpty) {
          return _buildRecentSearches(provider);
        }

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
            onRetry: () => provider.search(_searchController.text),
          );
        }

        // Empty results
        if (provider.results.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.search_off,
            message: 'No results found',
            subtitle: 'Try different keywords',
          );
        }

        // Results list
        return ListView.builder(
          itemCount: provider.results.length,
          itemBuilder: (context, index) {
            final article = provider.results[index];
            return SearchResultCard(
              article: article,
              query: _searchController.text,
              onTap: () {
                context.push('/article/${article.id}', extra: article);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildRecentSearches(SearchProvider provider) {
    if (provider.recentSearches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Search for news articles',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  provider.clearHistory();
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: provider.recentSearches.length,
            itemBuilder: (context, index) {
              final query = provider.recentSearches[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(query),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    provider.removeFromHistory(query);
                  },
                ),
                onTap: () {
                  _searchController.text = query;
                  provider.search(query);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
```

---

## Search Result Card Widget

### UI Specifications
```
┌────────────────────────────────────┐
│ ┌───┐  Article Title with          │
│ │IMG│  highlighted search term     │
│ └───┘  Source · 2h ago             │
└────────────────────────────────────┘
```

### Implementation
```dart
class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    super.key,
    required this.article,
    required this.query,
    this.onTap,
  });

  final Article article;
  final String query;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with highlighted search term
                    _buildHighlightedText(
                      article.title,
                      query,
                      context,
                    ),
                    const SizedBox(height: 8),
                    
                    // Metadata
                    Text(
                      '${article.source} · ${article.timeAgo}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(
    String text,
    String query,
    BuildContext context,
  ) {
    if (query.isEmpty) {
      return Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      );
    }

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),
          ),
          TextSpan(text: text.substring(index + query.length)),
        ],
      ),
    );
  }
}
```

---

## SearchProvider Implementation

### Provider Structure
```dart
class SearchProvider extends ChangeNotifier {
  final NewsRepository _repository;
  final PreferencesRepository _prefsRepository;

  SearchProvider({
    NewsRepository? repository,
    PreferencesRepository? prefsRepository,
  })  : _repository = repository ?? NewsRepository(),
        _prefsRepository = prefsRepository ?? PreferencesRepository();

  // State
  List<Article> _results = [];
  List<String> _recentSearches = [];
  LoadingState _state = LoadingState.initial;
  String? _errorMessage;
  String? _currentQuery;

  // Getters
  List<Article> get results => List.unmodifiable(_results);
  List<String> get recentSearches => List.unmodifiable(_recentSearches);
  LoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == LoadingState.loading;
  bool get hasError => _state == LoadingState.error;

  // Methods
  Future<void> search(String query) async {
    if (query.isEmpty) {
      clearResults();
      return;
    }

    _setState(LoadingState.loading);
    _currentQuery = query;

    try {
      final results = await _repository.searchNews(query: query);
      _results = results;
      _setState(LoadingState.loaded);
      
      // Save to search history
      _addToHistory(query);
    } catch (e) {
      _errorMessage = 'Search failed. Please try again.';
      _setState(LoadingState.error);
      debugPrint('Search error: $e');
    }
  }

  void clearResults() {
    _results = [];
    _currentQuery = null;
    _state = LoadingState.initial;
    notifyListeners();
  }

  Future<void> loadRecentSearches() async {
    _recentSearches = await _prefsRepository.getRecentSearches();
    notifyListeners();
  }

  Future<void> _addToHistory(String query) async {
    if (!_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      
      // Keep only last 10 searches
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.take(10).toList();
      }
      
      await _prefsRepository.saveRecentSearches(_recentSearches);
      notifyListeners();
    }
  }

  Future<void> removeFromHistory(String query) async {
    _recentSearches.remove(query);
    await _prefsRepository.saveRecentSearches(_recentSearches);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _recentSearches.clear();
    await _prefsRepository.saveRecentSearches([]);
    notifyListeners();
  }

  void _setState(LoadingState state) {
    _state = state;
    notifyListeners();
  }
}
```

---

## NewsRepository Extension

```dart
// In NewsRepository
Future<List<Article>> searchNews({required String query}) async {
  // No cache for search results (always fresh)
  return await _remoteSource.searchNews(query: query);
}
```

---

## Testing Checklist
- [ ] Search input accepts text
- [ ] Results appear after typing (debounced)
- [ ] Clear button clears input and results
- [ ] Recent searches display before typing
- [ ] Tap recent search executes search
- [ ] Search query highlighted in results
- [ ] Tap result opens article detail
- [ ] Can clear individual recent searches
- [ ] Can clear all search history
- [ ] Works in both light and dark mode

---

## Common Pitfalls
- ❌ Don't search on every keystroke (use debouncing)
- ❌ Don't store unlimited search history
- ✅ Debounce search by 500ms
- ✅ Limit recent searches to 10
- ✅ Clear results when input is cleared
- ✅ Handle empty results gracefully

---

## AdMob Integration

### Ad Placements
| Ad Type | Placement | Frequency |
|---------|-----------|-----------|
| Banner Ad | Below search bar | Persistent while searching |
| Native Ad | In search results | Every 5th result |

### Banner Ad Below Search
```dart
// In search_screen.dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(),
    body: Column(
      children: [
        // Banner below search bar (visible during search)
        if (_searchController.text.isNotEmpty)
          const BannerAdWidget(),
        
        // Search results or recent searches
        Expanded(child: _buildBody()),
      ],
    ),
  );
}
```

### Native Ads in Search Results
```dart
// In _buildBody when showing results
Widget _buildResults(SearchProvider provider) {
  final results = provider.results;
  final totalItems = results.length + (results.length ~/ 4); // 1 ad per 4 results
  
  return ListView.builder(
    itemCount: totalItems,
    itemBuilder: (context, index) {
      // Show native ad at positions 4, 9, 14... (every 5th item, 0-indexed)
      final isAdPosition = index > 0 && (index + 1) % 5 == 0;
      
      if (isAdPosition) {
        return const NativeAdWidget(
          templateType: NativeAdTemplateType.small, // Compact for search
        );
      }
      
      // Calculate actual result index
      final resultIndex = index - (index ~/ 5);
      if (resultIndex >= results.length) {
        return const SizedBox.shrink();
      }
      
      final article = results[resultIndex];
      return SearchResultCard(
        article: article,
        query: _searchController.text,
        onTap: () => context.push('/article/${article.id}', extra: article),
      );
    },
  );
}
```

### No Ads for Recent Searches
```dart
// Recent searches screen should NOT show ads (user hasn't searched yet)
if (_searchController.text.isEmpty) {
  return _buildRecentSearches(provider); // No ads here
}
```

### Testing Checklist (Ads)
- [ ] Banner appears only when searching (not on empty screen)
- [ ] Native ads appear every 5th search result
- [ ] No ads shown for recent searches view
- [ ] Ads don't interfere with search experience
- [ ] Query highlighting still works with ads in list

---

**Priority**: P0 (Must Have)
**Complexity**: Medium
**Estimated Time**: 3-4 hours
**Dependencies**: 
- SearchProvider
- NewsRepository
- PreferencesRepository
- Article model
- BannerAdWidget
- NativeAdWidget
