import 'package:flutter/foundation.dart';
import 'package:news_nest/data/models/article_model.dart';
import 'package:news_nest/data/repositories/bookmark_repository.dart';

/// BookmarkProvider manages saved/bookmarked articles
class BookmarkProvider extends ChangeNotifier {
  final BookmarkRepository _repository;

  BookmarkProvider({BookmarkRepository? repository})
    : _repository = repository ?? BookmarkRepository();

  // State
  List<Article> _bookmarks = [];
  bool _isLoading = false;

  // Getters
  List<Article> get bookmarks => List.unmodifiable(_bookmarks);
  bool get isLoading => _isLoading;
  int get count => _bookmarks.length;
  bool get isEmpty => _bookmarks.isEmpty;

  /// Load all bookmarks from local storage
  Future<void> loadBookmarks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookmarks = await _repository.getAllBookmarks();
    } catch (e) {
      debugPrint('Error loading bookmarks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Check if an article is bookmarked
  bool isBookmarked(String articleId) {
    return _bookmarks.any((article) => article.id == articleId);
  }

  /// Add a bookmark
  Future<void> addBookmark(Article article) async {
    try {
      await _repository.addBookmark(article);

      // Add to beginning of list (most recent first)
      final bookmarkedArticle = article.copyWith(bookmarkedAt: DateTime.now());
      _bookmarks.insert(0, bookmarkedArticle);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding bookmark: $e');
    }
  }

  /// Remove a bookmark
  Future<void> removeBookmark(Article article) async {
    try {
      await _repository.removeBookmark(article.id);
      _bookmarks.removeWhere((a) => a.id == article.id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing bookmark: $e');
    }
  }

  /// Toggle bookmark status
  Future<void> toggleBookmark(Article article) async {
    if (isBookmarked(article.id)) {
      await removeBookmark(article);
    } else {
      await addBookmark(article);
    }
  }

  /// Clear all bookmarks
  Future<void> clearAll() async {
    try {
      await _repository.clearAllBookmarks();
      _bookmarks.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing bookmarks: $e');
    }
  }

  /// Get a bookmark by ID (for restoration)
  Article? getBookmarkById(String articleId) {
    try {
      return _bookmarks.firstWhere((a) => a.id == articleId);
    } catch (_) {
      return null;
    }
  }
}
