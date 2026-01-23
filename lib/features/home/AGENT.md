# 📱 Home Feed Feature - Agent Instructions

## Feature Overview
The Home Feed is the main screen of NewsNest where users consume personalized news. It features a tabbed interface (For You, Local, Trending), category filtering, pull-to-refresh, infinite scroll, and bookmark/share actions.

## Files in This Feature

| File | Purpose | Lines (est.) |
|------|---------|--------------|
| `screens/home_screen.dart` | Main feed with tabs & logic | ~400 |
| `widgets/news_card.dart` | Full news card with image | ~150 |
| `widgets/news_card_compact.dart` | Compact variant | ~100 |
| `widgets/category_tabs.dart` | Horizontal category filter | ~80 |
| `widgets/shimmer_card.dart` | Loading skeleton | ~60 |

## State Management
- **Provider**: `NewsFeedProvider`
- **Dependencies**: `UserPreferencesProvider`, `BookmarkProvider`

---

## Home Screen Architecture

### Tab Structure
| Tab | Data Source | Filter |
|-----|-------------|--------|
| For You | Personalized based on user interests | User's selected categories |
| Local | City-specific news | User's selected city |
| Trending | Popular/breaking news | Top headlines |

### Screen Layout
```
┌─────────────────────────────────┐
│  AppBar (NewsNest logo + icons) │
├─────────────────────────────────┤
│  Category Tabs (Horizontal)     │ ← Scrollable
├─────────────────────────────────┤
│                                 │
│  ┌─────────────────────────┐   │
│  │   News Card             │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │   News Card             │   │ ← Pull-to-refresh
│  └─────────────────────────┘   │   Infinite scroll
│                                 │
│  ┌─────────────────────────┐   │
│  │   News Card             │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

---

## 1. Home Screen (`home_screen.dart`)

### Acceptance Criteria
- ✅ Display 3 tabs: For You, Local, Trending
- ✅ Show horizontal category tabs (user interests only)
- ✅ Load news articles for selected category
- ✅ Pull-to-refresh functionality
- ✅ Infinite scroll (pagination)
- ✅ Show shimmer loading on initial load
- ✅ Show error state with retry button
- ✅ Show empty state if no articles
- ✅ Navigate to article detail on card tap
- ✅ FAB (FloatingActionButton) for search

### AppBar Specifications
| Element | Details |
|---------|---------|
| Title | "NewsNest" (app name) |
| Leading | None |
| Actions | Bookmark icon, Settings icon |
| Background | Theme primary color |

### Tab Configuration
```dart
TabBarView(
  children: [
    _buildForYouTab(),    // Personalized feed
    _buildLocalTab(),     // City news
    _buildTrendingTab(),  // Popular news
  ],
)
```

### Category Tabs Widget Integration
```dart
// Show only in "For You" tab
if (currentTab == 0) {
  CategoryTabs(
    categories: userInterests,
    selectedCategory: selectedCategory,
    onCategorySelected: (category) {
      context.read<NewsFeedProvider>()
        .fetchNews(category: category);
    },
  ),
}
```

### Pull-to-Refresh Implementation
```dart
RefreshIndicator(
  onRefresh: () async {
    await context.read<NewsFeedProvider>()
      .fetchNews(refresh: true);
  },
  child: ListView.builder(...),
)
```

### Infinite Scroll Implementation
```dart
NotificationListener<ScrollNotification>(
  onNotification: (notification) {
    if (notification is ScrollEndNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels >= metrics.maxScrollExtent * 0.8) {
        // Load more when 80% scrolled
        final provider = context.read<NewsFeedProvider>();
        if (!provider.isLoadingMore && provider.hasMore) {
          provider.loadMore();
        }
      }
    }
    return false;
  },
  child: ListView.builder(...),
)
```

### State Handling Pattern
```dart
@override
Widget build(BuildContext context) {
  return Consumer<NewsFeedProvider>(
    builder: (context, provider, _) {
      // Loading state
      if (provider.state == LoadingState.loading) {
        return _buildShimmerList();
      }
      
      // Error state
      if (provider.hasError) {
        return ErrorWidget(
          message: provider.errorMessage,
          onRetry: () => provider.fetchNews(),
        );
      }
      
      // Empty state
      if (provider.articles.isEmpty) {
        return EmptyStateWidget(
          message: 'No articles found',
          icon: Icons.article_outlined,
        );
      }
      
      // Loaded state
      return _buildArticleList(provider);
    },
  );
}
```

### Navigation
```dart
// To article detail
context.push('/article/${article.id}', extra: article);

// To bookmarks
context.push('/bookmarks');

// To settings
context.push('/settings');

// To search (via FAB)
context.push('/search');
```

---

## 2. News Card Widget (`news_card.dart`)

### Acceptance Criteria
- ✅ Display article image (cached)
- ✅ Show article title (max 3 lines)
- ✅ Show source name and time ago
- ✅ Bookmark icon (toggle on tap)
- ✅ Tap card to open article detail
- ✅ Smooth animations (ripple, bookmark)
- ✅ Responsive design (adapts to screen width)

### UI Specifications
```
┌────────────────────────────────────┐
│  ┌──────────────────────────────┐ │
│  │                              │ │
│  │      Article Image           │ │ ← 16:9 aspect ratio
│  │      (CachedNetworkImage)    │ │   Height: 200dp
│  │                              │ │
│  └──────────────────────────────┘ │
│                                    │
│  Article Title (Bold, 3 lines)     │ ← Title Large
│  Lorem ipsum dolor sit amet...     │
│                                    │
│  Source Name · 2h ago  [bookmark]  │ ← Caption style
└────────────────────────────────────┘
   Padding: 16dp, Radius: 12dp
```

### Widget Structure
```dart
class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.article,
    this.onTap,
    this.onBookmark,
  });

  final Article article;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            _buildContent(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      child: CachedNetworkImage(
        imageUrl: article.imageUrl ?? '',
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: Icon(Icons.broken_image, size: 50),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Text('${article.source} · ${article.timeAgo}'),
        Spacer(),
        Selector<BookmarkProvider, bool>(
          selector: (_, provider) => 
            provider.isBookmarked(article.id),
          builder: (context, isBookmarked, _) {
            return IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? primary : grey,
              ),
              onPressed: () {
                context.read<BookmarkProvider>()
                  .toggleBookmark(article);
              },
            );
          },
        ),
      ],
    );
  }
}
```

### Image Caching
```dart
// Use cached_network_image package
CachedNetworkImage(
  imageUrl: article.imageUrl ?? '',
  placeholder: (context, url) => Shimmer.fromColors(...),
  errorWidget: (context, url, error) => Icon(Icons.broken_image),
  memCacheWidth: 600, // Optimize memory
)
```

---

## 3. News Card Compact (`news_card_compact.dart`)

### Use Case
- Used in "Trending" tab for denser layout
- Used in search results
- Used in related articles

### UI Specifications
```
┌────────────────────────────────────┐
│ ┌───┐  Article Title (2 lines)     │
│ │IMG│  Source · 1h ago  [bookmark] │ ← Compact, horizontal
│ └───┘                               │
└────────────────────────────────────┘
  Image: 80x80dp, Title: Body Medium
```

---

## 4. Category Tabs (`category_tabs.dart`)

### Acceptance Criteria
- ✅ Horizontal scrollable list
- ✅ Show user's selected interests
- ✅ Highlight selected category
- ✅ Smooth scroll to selected item
- ✅ Tap to filter news

### UI Specifications
```
┌─────────────────────────────────────────────┐
│ [All] [Tech] [Sports] [Business] [Politics]│ ← Horizontal scroll
│   ^                                         │   Selected: filled
│ Selected                                    │   Others: outlined
└─────────────────────────────────────────────┘
```

### Widget Structure
```dart
class CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: ['All', ...categories].length,
        itemBuilder: (context, index) {
          final category = index == 0 ? 'All' : categories[index - 1];
          final isSelected = category == selectedCategory;
          
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(category),
            ),
          );
        },
      ),
    );
  }
}
```

---

## 5. Shimmer Card (`shimmer_card.dart`)

### Purpose
Show loading skeleton matching NewsCard layout during data fetch.

### UI Specifications
```
┌────────────────────────────────────┐
│  ┌──────────────────────────────┐ │
│  │   [Shimmer rectangle]        │ │ ← Image placeholder
│  └──────────────────────────────┘ │
│  [Shimmer line]                    │ ← Title line 1
│  [Shimmer line]                    │ ← Title line 2
│  [Shimmer short line]              │ ← Title line 3
│  [Shimmer caption]                 │ ← Footer
└────────────────────────────────────┘
```

### Implementation
```dart
class ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(height: 200, color: Colors.grey),
            SizedBox(height: 16),
            Container(height: 16, color: Colors.grey),
            SizedBox(height: 8),
            Container(height: 16, width: 200, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// Usage in home_screen.dart
Widget _buildShimmerList() {
  return ListView.builder(
    itemCount: 5,
    itemBuilder: (context, index) => ShimmerCard(),
  );
}
```

---

## NewsFeedProvider Implementation

### Provider Structure
```dart
class NewsFeedProvider extends ChangeNotifier {
  final NewsRepository _repository;

  NewsFeedProvider({NewsRepository? repository})
      : _repository = repository ?? NewsRepository();

  // State
  List<Article> _articles = [];
  LoadingState _state = LoadingState.initial;
  String? _errorMessage;
  int _page = 1;
  bool _hasMore = true;
  String? _currentCategory;

  // Getters
  List<Article> get articles => List.unmodifiable(_articles);
  LoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == LoadingState.loading;
  bool get isLoadingMore => _state == LoadingState.loadingMore;
  bool get hasError => _state == LoadingState.error;
  bool get hasMore => _hasMore;

  // Methods
  Future<void> fetchNews({
    String? category,
    bool refresh = false,
  }) async {
    if (refresh) {
      _page = 1;
      _articles.clear();
    }

    _setState(LoadingState.loading);
    _currentCategory = category;

    try {
      final result = await _repository.getNews(
        category: category ?? 'All',
        page: _page,
      );

      _articles = result;
      _hasMore = result.length >= 20; // Assuming 20 items per page
      _setState(LoadingState.loaded);
    } catch (e) {
      _errorMessage = _handleError(e);
      _setState(LoadingState.error);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || isLoadingMore) return;

    _setState(LoadingState.loadingMore);
    _page++;

    try {
      final result = await _repository.getNews(
        category: _currentCategory ?? 'All',
        page: _page,
      );

      _articles.addAll(result);
      _hasMore = result.length >= 20;
      _setState(LoadingState.loaded);
    } catch (e) {
      _page--; // Revert page increment on error
      _errorMessage = _handleError(e);
      _setState(LoadingState.error);
    }
  }

  void _setState(LoadingState state) {
    _state = state;
    notifyListeners();
  }

  String _handleError(dynamic error) {
    if (error is NoInternetException) {
      return 'No internet connection';
    } else if (error is TimeoutException) {
      return 'Request timed out';
    }
    return 'Failed to load news';
  }

  @override
  void dispose() {
    // Clean up if needed
    super.dispose();
  }
}
```

---

## Routing Configuration

```dart
// In app_router.dart
GoRoute(
  path: '/home',
  name: 'home',
  builder: (context, state) => const HomeScreen(),
),
```

---

## Testing Checklist
- [ ] All three tabs display correctly
- [ ] Category filtering works
- [ ] Pull-to-refresh reloads data
- [ ] Infinite scroll loads more articles
- [ ] Bookmark icon toggles correctly
- [ ] Navigation to article detail works
- [ ] Shimmer appears during loading
- [ ] Error state shows with retry button
- [ ] Empty state displays when no articles
- [ ] Works in portrait and landscape
- [ ] Smooth scrolling performance

---

## Performance Optimizations
- ✅ Use `ListView.builder` (not ListView)
- ✅ Cache images with `CachedNetworkImage`
- ✅ Use `Selector` instead of `Consumer` where possible
- ✅ Implement pagination (not loading all at once)
- ✅ Dispose controllers/listeners properly
- ✅ Use `const` constructors

---

## Common Pitfalls
- ❌ Don't rebuild entire list on scroll
- ❌ Don't forget to paginate (infinite scroll)
- ❌ Don't load high-res images without caching
- ✅ Always show loading state first
- ✅ Handle image loading errors gracefully
- ✅ Use RepaintBoundary for expensive widgets

---

## AdMob Integration

### Ad Placements
| Ad Type | Placement | Frequency |
|---------|-----------|-----------|
| Native Ad | In news feed | Every 6th article |
| Banner Ad | Bottom of screen | Persistent |

### Native Ad Integration in Feed
```dart
// In _buildArticleList method
ListView.builder(
  itemCount: provider.articles.length + _calculateAdCount(provider.articles.length),
  itemBuilder: (context, index) {
    // Show native ad every 6th position (after 5 articles)
    // Ad positions: 5, 11, 17, 23...
    final isAdPosition = (index + 1) % 6 == 0;
    
    if (isAdPosition) {
      return const NativeAdWidget(
        templateType: NativeAdTemplateType.medium,
      );
    }
    
    // Calculate actual article index
    final articleIndex = index - (index ~/ 6);
    if (articleIndex >= provider.articles.length) {
      return const SizedBox.shrink();
    }
    
    final article = provider.articles[articleIndex];
    return NewsCard(article: article, ...);
  },
)

int _calculateAdCount(int articleCount) {
  return articleCount ~/ 5; // One ad per 5 articles
}
```

### Banner Ad at Bottom
```dart
// In home_screen.dart build method
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(),
    body: _buildBody(),
    bottomNavigationBar: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BannerAdWidget(), // Persistent banner
        // Bottom navigation if any
      ],
    ),
  );
}
```

### Ad Loading States
```dart
class NativeAdWidget extends StatefulWidget {
  final NativeAdTemplateType templateType;
  
  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: AdMobConstants.nativeAdId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Native ad failed: $error');
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: widget.templateType,
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _nativeAd == null) {
      // Return shimmer or empty space matching ad size
      return const SizedBox(height: 200);
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      height: 200,
      child: AdWidget(ad: _nativeAd!),
    );
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
}
```

### New User Grace Period
```dart
// Check if user is within grace period (first 3 app opens)
final shouldShowAds = await AdMobService.instance.shouldShowAds();

if (!shouldShowAds) {
  // Don't insert ads for new users
  return ListView.builder(
    itemCount: provider.articles.length,
    itemBuilder: (context, index) => NewsCard(...),
  );
}
```

### Testing Checklist (Ads)
- [ ] Native ads appear every 6th position in feed
- [ ] Banner ad visible at bottom of screen
- [ ] Ads don't show during first 3 app opens
- [ ] Scrolling is smooth with ads loaded
- [ ] Failed ads don't break the layout
- [ ] Ads adapt to dark mode

---

**Priority**: P0 (Must Have)
**Complexity**: High
**Estimated Time**: 6-8 hours
**Dependencies**: 
- NewsFeedProvider
- BookmarkProvider
- UserPreferencesProvider
- NewsRepository
- Article model
- AdMobService
- BannerAdWidget
- NativeAdWidget
