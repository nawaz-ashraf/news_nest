import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:news_nest/data/models/article_model.dart';

// Local data source for bookmarks using Hive
class BookmarkLocalSource {
  static const String boxName = 'bookmarks';

  // Get Hive box (untyped because we store Maps now)
  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }

  // Get all bookmarks
  Future<List<Article>> getBookmarks() async {
    final box = await _getBox();
    final bookmarks = <Article>[];

    for (var key in box.keys) {
      final map = box.get(key);
      if (map is Map) {
        // dynamic map key issue resolution if needed, but usually Map<String, dynamic> from generic Map
        try {
          // Hive might return Map<dynamic, dynamic>, need to cast for fromJson
          final jsonMap = Map<String, dynamic>.from(map);
          bookmarks.add(Article.fromJson(jsonMap));
        } catch (e) {
          // Skip invalid entries
          debugPrint('Error parsing bookmark $key: $e');
        }
      }
    }

    // Sort by bookmarked time, most recent first
    bookmarks.sort((a, b) {
      final aTime = a.bookmarkedAt ?? a.publishedAt;
      final bTime = b.bookmarkedAt ?? b.publishedAt;
      return bTime.compareTo(aTime);
    });

    return bookmarks;
  }

  // Add bookmark
  Future<void> addBookmark(Article article) async {
    final box = await _getBox();

    // Add bookmarkedAt timestamp
    final bookmarkedArticle = article.copyWith(bookmarkedAt: DateTime.now());

    // Convert to Map
    await box.put(article.id, bookmarkedArticle.toJson());
  }

  // Remove bookmark
  Future<void> removeBookmark(String articleId) async {
    final box = await _getBox();
    await box.delete(articleId);
  }

  // Check if article is bookmarked
  Future<bool> isBookmarked(String articleId) async {
    final box = await _getBox();
    return box.containsKey(articleId);
  }

  // Clear all bookmarks
  Future<void> clearAll() async {
    final box = await _getBox();
    await box.clear();
  }

  // Get bookmark count
  Future<int> getCount() async {
    final box = await _getBox();
    return box.length;
  }
}
