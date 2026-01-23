# 🔖 Bookmarks Feature - Agent Instructions

## Feature Overview
The Bookmarks feature allows users to save articles for offline reading. Articles are persisted locally using Hive, enabling access even without internet connection.

## Files in This Feature

| File | Purpose |
|------|---------|
| `screens/bookmarks_screen.dart` | Saved articles list |
| `widgets/bookmark_card.dart` | Bookmark list item widget |

---

## Bookmarks Screen

### Acceptance Criteria
- ✅ Display all saved/bookmarked articles
- ✅ Offline access (no internet required)
- ✅ Swipe-to-delete gesture with undo
- ✅ Tap to open article detail
- ✅ Show empty state when no bookmarks
- ✅ Sort by most recently added first
- ✅ Show total bookmark count
- ✅ Remove all option (with confirmation)

### Screen Layout
```
┌─────────────────────────────────────┐
│  ← Back    Bookmarks (12)       [⋮] │ ← Count + menu
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ← Swipe to delete           │   │
│  │   News Card                 │   │
│  │   Saved 2 hours ago         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │   News Card                 │   │
│  │   Saved 1 day ago           │   │
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
  path: '/bookmarks',
  name: 'bookmarks',
  builder: (context, state) => const BookmarksScreen(),
),
```

### Screen Structure
```dart
class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookmarkProvider>().loadBookmarks();
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
      title: Selector<BookmarkProvider, int>(
        selector: (_, provider) => provider.bookmarks.length,
        builder: (context, count, _) {
          return Text('Bookmarks ($count)');
        },
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'clear',
              child: Text('Remove all'),
            ),
          ],
          onSelected: (value) {
            if (value == 'clear') {
              _confirmClearAll();
            }
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<BookmarkProvider>(
      builder: (context, provider, _) {
        // Empty state
        if (provider.bookmarks.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.bookmark_border,
            message: 'No saved articles yet',
            subtitle: 'Bookmark articles to read them offline',
          );
        }

        // Bookmarks list
        return ListView.builder(
          itemCount: provider.bookmarks.length,
          itemBuilder: (context, index) {
            final article = provider.bookmarks[index];
            return Dismissible(
              key: Key(article.id),
              direction: DismissDirection.endToStart,
              background: _buildDismissBackground(),
              onDismissed: (_) {
                _removeBookmark(article, index);
              },
              child: BookmarkCard(
                article: article,
                onTap: () {
                  context.push('/article/${article.id}', extra: article);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  void _removeBookmark(Article article, int index) {
    final provider = context.read<BookmarkProvider>();
    provider.removeBookmark(article);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Bookmark removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            provider.addBookmark(article);
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _confirmClearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove all bookmarks?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove all'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      context.read<BookmarkProvider>().clearAll();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All bookmarks removed')),
      );
    }
  }
}
```

---

## Bookmark Card Widget

### UI Specifications
```
┌────────────────────────────────────┐
│ ┌───┐  Article Title               │
│ │IMG│  Source · Saved 2h ago       │
│ └───┘                               │
└────────────────────────────────────┘
  Compact layout, similar to NewsCardCompact
```

### Implementation
```dart
class BookmarkCard extends StatelessWidget {
  const BookmarkCard({
    super.key,
    required this.article,
    this.onTap,
  });

  final Article article;
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
                    // Title
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    
                    // Metadata
                    Row(
                      children: [
                        Icon(
                          Icons.bookmark,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${article.source} · Saved ${article.bookmarkedTimeAgo}',
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
}
```

---

## BookmarkProvider Implementation

### Provider Structure
```dart
class BookmarkProvider extends ChangeNotifier {
  final BookmarkRepository _repository;

  BookmarkProvider({BookmarkRepository? repository})
      : _repository = repository ?? BookmarkRepository();

  // State
  List<Article> _bookmarks = [];
  
  // Getters
  List<Article> get bookmarks => List.unmodifiable(_bookmarks);
  
  bool isBookmarked(String articleId) {
    return _bookmarks.any((article) => article.id == articleId);
  }

  // Methods
  Future<void> loadBookmarks() async {
    try {
      _bookmarks = await _repository.getAllBookmarks();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading bookmarks: $e');
    }
  }

  Future<void> addBookmark(Article article) async {
    try {
      await _repository.addBookmark(article);
      _bookmarks.insert(0, article); // Add to beginning
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding bookmark: $e');
    }
  }

  Future<void> removeBookmark(Article article) async {
    try {
      await _repository.removeBookmark(article.id);
      _bookmarks.removeWhere((a) => a.id == article.id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing bookmark: $e');
    }
  }

  Future<void> toggleBookmark(Article article) async {
    if (isBookmarked(article.id)) {
      await removeBookmark(article);
    } else {
      await addBookmark(article);
    }
  }

  Future<void> clearAll() async {
    try {
      await _repository.clearAllBookmarks();
      _bookmarks.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing bookmarks: $e');
    }
  }
}
```

---

## BookmarkRepository Implementation

### Using Hive for Local Storage
```dart
class BookmarkRepository {
  final BookmarkLocalSource _localSource;

  BookmarkRepository({BookmarkLocalSource? localSource})
      : _localSource = localSource ?? BookmarkLocalSource();

  Future<List<Article>> getAllBookmarks() async {
    return await _localSource.getBookmarks();
  }

  Future<void> addBookmark(Article article) async {
    await _localSource.saveBookmark(article);
  }

  Future<void> removeBookmark(String articleId) async {
    await _localSource.deleteBookmark(articleId);
  }

  Future<void> clearAllBookmarks() async {
    await _localSource.clearAll();
  }
}
```

### BookmarkLocalSource (Hive)
```dart
class BookmarkLocalSource {
  static const String boxName = 'bookmarks';

  Future<Box<Article>> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<Article>(boxName);
    }
    return Hive.box<Article>(boxName);
  }

  Future<List<Article>> getBookmarks() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<void> saveBookmark(Article article) async {
    final box = await _getBox();
    await box.put(article.id, article);
  }

  Future<void> deleteBookmark(String articleId) async {
    final box = await _getBox();
    await box.delete(articleId);
  }

  Future<void> clearAll() async {
    final box = await _getBox();
    await box.clear();
  }
}
```

---

## Article Model Extension

Add Hive adapter for Article model:

```dart
// In article_model.dart
import 'package:hive/hive.dart';

part 'article_model.g.dart';

@HiveType(typeId: 0)
class Article {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String? description;
  
  @HiveField(3)
  final String? imageUrl;
  
  @HiveField(4)
  final String source;
  
  @HiveField(5)
  final DateTime publishedAt;
  
  @HiveField(6)
  final String? url;
  
  @HiveField(7)
  final String category;
  
  @HiveField(8)
  final DateTime? bookmarkedAt;

  // ... rest of the class
}
```

Then run: `flutter packages pub run build_runner build`

---

## Testing Checklist
- [ ] Can add bookmarks from article detail
- [ ] Bookmarks persist after app restart
- [ ] Can remove bookmarks via swipe
- [ ] Undo works within 3 seconds
- [ ] Can remove all bookmarks with confirmation
- [ ] Empty state shows when no bookmarks
- [ ] Bookmarks sorted by most recent first
- [ ] Tap opens article detail (offline capable)
- [ ] Works in both light and dark mode

---

## Common Pitfalls
- ❌ Don't forget to initialize Hive in main.dart
- ❌ Don't forget to register Article adapter
- ✅ Handle Hive box not open errors
- ✅ Add timestamp when bookmarking (for "Saved Xh ago")
- ✅ Confirm before clearing all bookmarks
- ✅ Show undo option after removal

---

## AdMob Integration

### Ad Placements
| Ad Type | Placement | Notes |
|---------|-----------|-------|
| Banner Ad | Bottom of screen | Persistent, below bookmark list |

### Banner Ad Implementation
```dart
// In bookmarks_screen.dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(),
    body: _buildBody(),
    bottomNavigationBar: const BannerAdWidget(), // Persistent banner
  );
}
```

### Ad-free for Empty State
```dart
// Don't show banner if no bookmarks (better UX)
Consumer<BookmarkProvider>(
  builder: (context, provider, _) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      // Only show ad if user has bookmarks
      bottomNavigationBar: provider.bookmarks.isNotEmpty 
          ? const BannerAdWidget() 
          : null,
    );
  },
)
```

### Testing Checklist (Ads)
- [ ] Banner ad appears at bottom of bookmarks screen
- [ ] Banner doesn't show when bookmarks are empty
- [ ] Ad loads without disrupting swipe-to-delete
- [ ] Ad adapts to theme changes

---

**Priority**: P0 (Must Have)
**Complexity**: Medium
**Estimated Time**: 3-4 hours
**Dependencies**: 
- BookmarkProvider
- BookmarkRepository
- Hive package
- Article model with Hive adapter
- BannerAdWidget
