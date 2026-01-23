# 📖 Article Detail Feature - Agent Instructions

## Feature Overview
The Article Detail screen displays the full content of a selected news article with reading progress tracking, bookmark/share actions, related articles, and WebView fallback for external content.

## Files in This Feature

| File | Purpose |
|------|---------|
| `screens/article_detail_screen.dart` | Full article view with actions |
| `widgets/related_articles.dart` | Horizontal related articles carousel |

---

## Article Detail Screen

### Acceptance Criteria
- ✅ Display article title, image, source, published date
- ✅ Show article content (description/body text)
- ✅ Reading progress bar at top
- ✅ Bookmark button (persistent state)
- ✅ Share button (system share sheet)
- ✅ "Read Full Article" button → WebView or external browser
- ✅ Related articles section at bottom
- ✅ Smooth scroll animations
- ✅ Back navigation gesture support

### Screen Layout
```
┌─────────────────────────────────────┐
│ ← Back     Progress Bar    [⋮]      │ ← AppBar (translucent)
├─────────────────────────────────────┤
│                                     │
│      Article Image (Hero)           │ ← Full width image
│                                     │
├─────────────────────────────────────┤
│  Article Title (Large, Bold)        │
│  Multiple lines supported           │
│                                     │
│  Source Name · 2 hours ago          │
│                                     │
│  Lorem ipsum dolor sit amet,        │
│  consectetur adipiscing elit...     │ ← Article content
│  Sed do eiusmod tempor incididunt   │   (scrollable)
│  ut labore et dolore magna aliqua.  │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Read Full Article →        │   │ ← CTA Button
│  └─────────────────────────────┘   │
│                                     │
│  Related Articles                   │
│  ┌───┐ ┌───┐ ┌───┐               │ ← Horizontal scroll
│  │   │ │   │ │   │               │
│  └───┘ └───┘ └───┘               │
│                                     │
└─────────────────────────────────────┘
  Floating: [Bookmark] [Share]
```

### UI Specifications

| Element | Details |
|---------|---------|
| AppBar | Transparent background, back button, menu |
| Progress Bar | Linear indicator showing scroll progress |
| Image | Hero animation from list, full width |
| Title | Display Large, max 5 lines |
| Metadata | Source + time, Caption style |
| Content | Body Medium, readable padding |
| FABs | Bookmark + Share buttons |

---

## Implementation

### Route Configuration
```dart
// In app_router.dart
GoRoute(
  path: '/article/:id',
  name: 'article-detail',
  builder: (context, state) {
    final articleId = state.pathParameters['id']!;
    final article = state.extra as Article; // Passed from home
    return ArticleDetailScreen(article: article);
  },
),
```

### Screen Structure
```dart
class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollProgress);
    _fetchRelatedArticles();
  }

  void _updateScrollProgress() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    setState(() {
      _scrollProgress = (currentScroll / maxScroll).clamp(0.0, 1.0);
    });
  }

  Future<void> _fetchRelatedArticles() async {
    // Fetch articles in same category
    await context.read<NewsFeedProvider>()
      .fetchRelatedArticles(widget.article.category);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(),
          _buildContent(),
        ],
      ),
      floatingActionButton: _buildActionButtons(),
    );
  }
}
```

### AppBar with Progress Indicator
```dart
Widget _buildAppBar() {
  return SliverAppBar(
    expandedHeight: 300,
    pinned: true,
    flexibleSpace: FlexibleSpaceBar(
      background: Hero(
        tag: 'article-${widget.article.id}',
        child: CachedNetworkImage(
          imageUrl: widget.article.imageUrl ?? '',
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
          ),
        ),
      ),
    ),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(4),
      child: LinearProgressIndicator(
        value: _scrollProgress,
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation(
          Theme.of(context).colorScheme.secondary,
        ),
      ),
    ),
  );
}
```

### Content Section
```dart
Widget _buildContent() {
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.article.title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Metadata
          Row(
            children: [
              Icon(Icons.newspaper, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                '${widget.article.source} · ${widget.article.timeAgo}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Article content
          Text(
            widget.article.description ?? 'No description available.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          
          // Read full article button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openFullArticle,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Read Full Article'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 48),
          
          // Related articles
          Text(
            'Related Articles',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          RelatedArticles(category: widget.article.category),
        ],
      ),
    ),
  );
}
```

### Action Buttons (Bookmark & Share)
```dart
Widget _buildActionButtons() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Bookmark button
      Selector<BookmarkProvider, bool>(
        selector: (_, provider) => 
          provider.isBookmarked(widget.article.id),
        builder: (context, isBookmarked, _) {
          return FloatingActionButton(
            heroTag: 'bookmark',
            onPressed: () {
              context.read<BookmarkProvider>()
                .toggleBookmark(widget.article);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isBookmarked 
                      ? 'Removed from bookmarks' 
                      : 'Added to bookmarks'
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
          );
        },
      ),
      const SizedBox(height: 16),
      
      // Share button
      FloatingActionButton(
        heroTag: 'share',
        onPressed: _shareArticle,
        child: const Icon(Icons.share),
      ),
    ],
  );
}
```

### Share Functionality
```dart
Future<void> _shareArticle() async {
  final article = widget.article;
  final shareText = '''
${article.title}

Read more: ${article.url}

Shared via NewsNest
  ''';

  try {
    await Share.share(
      shareText,
      subject: article.title,
    );
  } catch (e) {
    debugPrint('Error sharing: $e');
  }
}
```

### Open Full Article (WebView/Browser)
```dart
Future<void> _openFullArticle() async {
  final url = widget.article.url;
  
  if (url == null || url.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Article URL not available')),
    );
    return;
  }

  final uri = Uri.parse(url);
  
  // Option 1: Open in external browser
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open article')),
    );
  }
  
  // Option 2: WebView in-app (if you implement WebView screen)
  // context.push('/webview', extra: url);
}
```

---

## Related Articles Widget

### Purpose
Display horizontal scrollable list of articles from the same category.

### UI Specifications
```
Related Articles
┌────────────────────────────────────────────┐
│ ┌─────────┐  ┌─────────┐  ┌─────────┐    │
│ │  Image  │  │  Image  │  │  Image  │    │ ← Horizontal scroll
│ │  Title  │  │  Title  │  │  Title  │    │
│ └─────────┘  └─────────┘  └─────────┘    │
└────────────────────────────────────────────┘
  Width: 180dp per card
```

### Implementation
```dart
class RelatedArticles extends StatelessWidget {
  const RelatedArticles({
    super.key,
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    return Selector<NewsFeedProvider, List<Article>>(
      selector: (_, provider) => provider.relatedArticles,
      builder: (context, articles, _) {
        if (articles.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: articles.length.clamp(0, 10), // Max 10
            itemBuilder: (context, index) {
              final article = articles[index];
              return _RelatedArticleCard(article: article);
            },
          ),
        );
      },
    );
  }
}

class _RelatedArticleCard extends StatelessWidget {
  final Article article;

  const _RelatedArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to article detail
        context.push('/article/${article.id}', extra: article);
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              CachedNetworkImage(
                imageUrl: article.imageUrl ?? '',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                ),
              ),
              
              // Title
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  article.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## NewsFeedProvider Extension

Add method to fetch related articles:

```dart
// In NewsFeedProvider
List<Article> _relatedArticles = [];

List<Article> get relatedArticles => _relatedArticles;

Future<void> fetchRelatedArticles(String category) async {
  try {
    final result = await _repository.getNews(
      category: category,
      page: 1,
    );
    
    _relatedArticles = result.take(10).toList();
    notifyListeners();
  } catch (e) {
    debugPrint('Error fetching related articles: $e');
    // Fail silently, related articles are optional
  }
}
```

---

## Hero Animation

Enable smooth transition from list to detail:

```dart
// In news_card.dart (list)
Hero(
  tag: 'article-${article.id}',
  child: CachedNetworkImage(...),
)

// In article_detail_screen.dart
Hero(
  tag: 'article-${widget.article.id}',
  child: CachedNetworkImage(...),
)
```

---

## Testing Checklist
- [ ] Article content displays correctly
- [ ] Hero animation works from home to detail
- [ ] Reading progress bar updates on scroll
- [ ] Bookmark toggles and persists
- [ ] Share opens system share sheet
- [ ] "Read Full Article" opens external browser
- [ ] Related articles load and navigate correctly
- [ ] Back button works (preserves home scroll position)
- [ ] Works in dark mode
- [ ] Handles missing images gracefully

---

## Common Pitfalls
- ❌ Don't forget to dispose ScrollController
- ❌ Don't fetch related articles on every scroll
- ✅ Use Hero tags for smooth transitions
- ✅ Handle null/empty article URLs
- ✅ Show loading state for related articles
- ✅ Clamp scroll progress between 0.0 - 1.0

---

## Dependencies
```yaml
# Already in pubspec
url_launcher: ^6.2.3
share_plus: ^7.2.2
cached_network_image: ^3.3.1
```

---

## AdMob Integration

### Ad Placements
| Ad Type | Placement | Trigger |
|---------|-----------|---------|
| Banner Ad | Below article content | Always visible |
| Interstitial Ad | On exit | After reading 3 articles |

### Banner Ad Placement
```dart
// In _buildContent method, add banner above Related Articles
Widget _buildContent() {
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... article content ...
          
          // Read full article button
          _buildReadFullArticleButton(),
          const SizedBox(height: 24),
          
          // Banner Ad (above related articles)
          const BannerAdWidget(),
          const SizedBox(height: 24),
          
          // Related articles
          Text('Related Articles', ...),
          RelatedArticles(category: widget.article.category),
        ],
      ),
    ),
  );
}
```

### Interstitial Ad Trigger
```dart
class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  void initState() {
    super.initState();
    _trackArticleRead();
  }

  Future<void> _trackArticleRead() async {
    final adService = AdMobService.instance;
    await adService.incrementArticleCount();
    
    // Check if we should show interstitial (every 3 articles)
    if (await adService.shouldShowInterstitial()) {
      _preloadInterstitial();
    }
  }

  InterstitialAd? _interstitialAd;

  void _preloadInterstitial() {
    InterstitialAd.load(
      adUnitId: AdMobConstants.interstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed to load: $error');
        },
      ),
    );
  }

  // Show on back navigation
  Future<bool> _onWillPop() async {
    if (_interstitialAd != null) {
      await _interstitialAd!.show();
      return false; // Navigation happens after ad closes
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(...),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }
}
```

### AdMob Service Methods
```dart
// In AdMobService
Future<void> incrementArticleCount() async {
  final prefs = await SharedPreferences.getInstance();
  final count = prefs.getInt(StorageKeys.articleReadCount) ?? 0;
  await prefs.setInt(StorageKeys.articleReadCount, count + 1);
}

Future<bool> shouldShowInterstitial() async {
  final prefs = await SharedPreferences.getInstance();
  final count = prefs.getInt(StorageKeys.articleReadCount) ?? 0;
  final lastShown = prefs.getInt(StorageKeys.lastInterstitialTime) ?? 0;
  final now = DateTime.now().millisecondsSinceEpoch;
  
  // Show every 3 articles with 45-second cooldown
  return count % 3 == 0 && 
         count > 0 && 
         (now - lastShown) > 45000;
}
```

### Testing Checklist (Ads)
- [ ] Banner ad appears below article content
- [ ] Interstitial shows after reading 3rd article
- [ ] Interstitial respects 45-second cooldown
- [ ] Back navigation shows interstitial when loaded
- [ ] Ads don't interrupt reading flow
- [ ] Failed ads don't block navigation

---

**Priority**: P0 (Must Have)
**Complexity**: Medium
**Estimated Time**: 3-4 hours
**Dependencies**: 
- BookmarkProvider
- NewsFeedProvider
- Article model
- Share Plus package
- URL Launcher package
- AdMobService
- BannerAdWidget
- InterstitialAdManager
