import 'package:news_nest/data/datasources/remote/news_api_service.dart';
import 'package:news_nest/data/models/article_model.dart';
import 'package:news_nest/data/models/news_api_response.dart';
import 'package:news_nest/core/network/api_exceptions.dart';

// News Repository - coordinates between API and local cache
class NewsRepository {
  final NewsApiService _remoteSource;

  NewsRepository({NewsApiService? remoteSource})
    : _remoteSource = remoteSource ?? NewsApiService();

  // Get news articles with pagination support
  Future<NewsApiResponse> getNews({
    String? category,
    String? page, // nextPage token for pagination
  }) async {
    try {
      return await _remoteSource.fetchNews(category: category, nextPage: page);
    } catch (e) {
      if (e is NoInternetException) {
        return NewsApiResponse.empty();
      }
      rethrow;
    }
  }

  // Get local/city news with pagination
  Future<NewsApiResponse> getLocalNews({
    required String city,
    String? page,
  }) async {
    try {
      return await _remoteSource.fetchLocalNews(city: city, nextPage: page);
    } catch (e) {
      if (e is NoInternetException) {
        return NewsApiResponse.empty();
      }
      rethrow;
    }
  }

  // Search news (no pagination for simplicity)
  Future<List<Article>> searchNews({required String query}) async {
    try {
      final response = await _remoteSource.searchNews(query: query);
      return response.articles;
    } catch (e) {
      if (e is NoInternetException) {
        return [];
      }
      rethrow;
    }
  }

  // Get trending news
  Future<List<Article>> getTrendingNews() async {
    try {
      final response = await _remoteSource.fetchTrendingNews();
      return response.articles;
    } catch (e) {
      if (e is NoInternetException) {
        return [];
      }
      rethrow;
    }
  }
}
