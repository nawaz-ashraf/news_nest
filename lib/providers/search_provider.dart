import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:news_nest/data/models/article_model.dart';
import 'package:news_nest/data/models/loading_state.dart';
import 'package:news_nest/data/repositories/news_repository.dart';
import 'package:news_nest/data/repositories/preferences_repository.dart';

/// SearchProvider manages news search functionality
class SearchProvider extends ChangeNotifier {
  final NewsRepository _newsRepository;
  final PreferencesRepository _prefsRepository;

  SearchProvider({
    NewsRepository? newsRepository,
    PreferencesRepository? prefsRepository,
  }) : _newsRepository = newsRepository ?? NewsRepository(),
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
  String? get currentQuery => _currentQuery;
  bool get isLoading => _state == LoadingState.loading;
  bool get hasError => _state == LoadingState.error;
  bool get hasResults => _results.isNotEmpty;
  bool get isEmpty => _results.isEmpty && _state == LoadingState.loaded;

  /// Search for news articles
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      clearResults();
      return;
    }

    _setState(LoadingState.loading);
    _currentQuery = query.trim();
    _errorMessage = null;

    try {
      final searchResults = await _newsRepository.searchNews(query: query);
      _results = searchResults;
      _setState(LoadingState.loaded);

      // Save to search history
      await _addToHistory(query.trim());
    } catch (e) {
      _errorMessage = 'Search failed. Please try again.';
      _setState(LoadingState.error);
      debugPrint('Search error: $e');
    }
  }

  /// Clear search results
  void clearResults() {
    _results.clear();
    _currentQuery = null;
    _state = LoadingState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  /// Load recent searches from storage
  Future<void> loadRecentSearches() async {
    try {
      _recentSearches = await _prefsRepository.getRecentSearches();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading recent searches: $e');
    }
  }

  /// Add query to search history
  Future<void> _addToHistory(String query) async {
    // Remove if already exists (to move to front)
    _recentSearches.remove(query);

    // Add to beginning
    _recentSearches.insert(0, query);

    // Keep only last 10 searches
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.take(10).toList();
    }

    await _prefsRepository.saveRecentSearches(_recentSearches);
    notifyListeners();
  }

  /// Remove a query from history
  Future<void> removeFromHistory(String query) async {
    _recentSearches.remove(query);
    await _prefsRepository.saveRecentSearches(_recentSearches);
    notifyListeners();
  }

  /// Clear all search history
  Future<void> clearHistory() async {
    _recentSearches.clear();
    await _prefsRepository.saveRecentSearches([]);
    notifyListeners();
  }

  void _setState(LoadingState newState) {
    _state = newState;
    notifyListeners();
  }
}
