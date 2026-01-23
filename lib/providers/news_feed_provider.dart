import 'package:flutter/foundation.dart';
import 'package:news_nest/core/network/api_exceptions.dart';
import 'package:news_nest/data/models/article_model.dart';
import 'package:news_nest/data/models/loading_state.dart';
import 'package:news_nest/data/repositories/news_repository.dart';

/// NewsFeedProvider manages the main news feed state
class NewsFeedProvider extends ChangeNotifier {
  final NewsRepository _repository;

  NewsFeedProvider({NewsRepository? repository})
    : _repository = repository ?? NewsRepository();

  // State
  List<Article> _articles = [];
  List<Article> _relatedArticles = [];
  LoadingState _state = LoadingState.initial;
  String? _errorMessage;
  String? _nextPage; // NewsData.io uses nextPage token
  bool _hasMore = true;
  String? _currentCategory;

  // Getters
  List<Article> get articles => List.unmodifiable(_articles);
  List<Article> get relatedArticles => List.unmodifiable(_relatedArticles);
  LoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == LoadingState.loading;
  bool get isLoadingMore => _state == LoadingState.loadingMore;
  bool get hasError => _state == LoadingState.error;
  bool get hasMore => _hasMore;
  bool get isEmpty => _articles.isEmpty && _state == LoadingState.loaded;
  String? get currentCategory => _currentCategory;

  /// Fetch news articles
  Future<void> fetchNews({String? category, bool refresh = false}) async {
    // If refresh, reset pagination
    if (refresh) {
      _nextPage = null;
      _articles.clear();
      _hasMore = true;
    }

    // Don't reload if already loading
    if (_state == LoadingState.loading) return;

    _setState(LoadingState.loading);
    _currentCategory = category;
    _errorMessage = null;

    try {
      final result = await _repository.getNews(
        category: category,
        page: _nextPage,
      );

      _articles = result.articles;
      _nextPage = result.nextPage;
      _hasMore = result.nextPage != null;
      _setState(LoadingState.loaded);
    } catch (e) {
      _errorMessage = _handleError(e);
      _setState(LoadingState.error);
    }
  }

  /// Load more articles (pagination)
  Future<void> loadMore() async {
    if (!_hasMore || isLoadingMore || isLoading) return;

    _setState(LoadingState.loadingMore);

    try {
      final result = await _repository.getNews(
        category: _currentCategory,
        page: _nextPage,
      );

      _articles.addAll(result.articles);
      _nextPage = result.nextPage;
      _hasMore = result.nextPage != null;
      _setState(LoadingState.loaded);
    } catch (e) {
      _errorMessage = _handleError(e);
      // Don't set error state for load more, just notify
      _setState(LoadingState.loaded);
      debugPrint('Error loading more: $e');
    }
  }

  /// Fetch related articles for article detail
  Future<void> fetchRelatedArticles(String category) async {
    try {
      final result = await _repository.getNews(
        category: category,
        page: null, // First page only
      );

      _relatedArticles = result.articles.take(10).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching related articles: $e');
      // Fail silently, related articles are optional
    }
  }

  /// Clear related articles
  void clearRelatedArticles() {
    _relatedArticles.clear();
    notifyListeners();
  }

  /// Refresh the current feed
  Future<void> refresh() async {
    await fetchNews(category: _currentCategory, refresh: true);
  }

  void _setState(LoadingState newState) {
    _state = newState;
    notifyListeners();
  }

  String _handleError(dynamic error) {
    if (error is NoInternetException) {
      return 'No internet connection. Please check your network.';
    } else if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    } else if (error is ServerException) {
      return 'Server error. Please try again later.';
    }
    return 'Failed to load news. Please try again.';
  }
}
