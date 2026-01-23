import 'package:flutter/foundation.dart';
import 'package:news_nest/core/network/api_exceptions.dart';
import 'package:news_nest/data/models/article_model.dart';
import 'package:news_nest/data/models/loading_state.dart';
import 'package:news_nest/data/repositories/news_repository.dart';

/// LocalNewsProvider manages city-specific local news
class LocalNewsProvider extends ChangeNotifier {
  final NewsRepository _repository;

  LocalNewsProvider({NewsRepository? repository})
    : _repository = repository ?? NewsRepository();

  // State
  List<Article> _articles = [];
  LoadingState _state = LoadingState.initial;
  String? _errorMessage;
  String? _nextPage;
  bool _hasMore = true;
  String? _currentCity;

  // Getters
  List<Article> get articles => List.unmodifiable(_articles);
  LoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == LoadingState.loading;
  bool get isLoadingMore => _state == LoadingState.loadingMore;
  bool get hasError => _state == LoadingState.error;
  bool get hasMore => _hasMore;
  bool get isEmpty => _articles.isEmpty && _state == LoadingState.loaded;
  String? get currentCity => _currentCity;

  /// Fetch local news for a city
  Future<void> fetchLocalNews({
    required String city,
    bool refresh = false,
  }) async {
    // If city changed or refresh, reset pagination
    if (city != _currentCity || refresh) {
      _nextPage = null;
      _articles.clear();
      _hasMore = true;
    }

    if (_state == LoadingState.loading) return;

    _setState(LoadingState.loading);
    _currentCity = city;
    _errorMessage = null;

    try {
      final result = await _repository.getLocalNews(
        city: city,
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

  /// Load more local news (pagination)
  Future<void> loadMore() async {
    if (!_hasMore || isLoadingMore || isLoading || _currentCity == null) return;

    _setState(LoadingState.loadingMore);

    try {
      final result = await _repository.getLocalNews(
        city: _currentCity!,
        page: _nextPage,
      );

      _articles.addAll(result.articles);
      _nextPage = result.nextPage;
      _hasMore = result.nextPage != null;
      _setState(LoadingState.loaded);
    } catch (e) {
      debugPrint('Error loading more local news: $e');
      _setState(LoadingState.loaded);
    }
  }

  /// Refresh local news
  Future<void> refresh() async {
    if (_currentCity != null) {
      await fetchLocalNews(city: _currentCity!, refresh: true);
    }
  }

  /// Clear local news (when city changes)
  void clear() {
    _articles.clear();
    _nextPage = null;
    _hasMore = true;
    _currentCity = null;
    _state = LoadingState.initial;
    notifyListeners();
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
    }
    return 'Failed to load local news. Please try again.';
  }
}
