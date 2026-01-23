import '../datasources/local/bookmark_local_source.dart';
import '../models/article_model.dart';

// Bookmark Repository
class BookmarkRepository {
  final BookmarkLocalSource _localSource;

  BookmarkRepository({BookmarkLocalSource? localSource})
    : _localSource = localSource ?? BookmarkLocalSource();

  // Get all bookmarks
  Future<List<Article>> getAllBookmarks() async {
    return await _localSource.getBookmarks();
  }

  // Add bookmark
  Future<void> addBookmark(Article article) async {
    await _localSource.addBookmark(article);
  }

  // Remove bookmark
  Future<void> removeBookmark(String articleId) async {
    await _localSource.removeBookmark(articleId);
  }

  // Check if bookmarked
  Future<bool> isBookmarked(String articleId) async {
    return await _localSource.isBookmarked(articleId);
  }

  // Toggle bookmark
  Future<void> toggleBookmark(Article article) async {
    final isBookmarked = await _localSource.isBookmarked(article.id);
    if (isBookmarked) {
      await _localSource.removeBookmark(article.id);
    } else {
      await _localSource.addBookmark(article);
    }
  }

  // Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    await _localSource.clearAll();
  }

  // Get bookmark count
  Future<int> getBookmarkCount() async {
    return await _localSource.getCount();
  }
}
