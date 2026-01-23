import 'package:flutter/foundation.dart';
import 'package:news_nest/core/constants/api_constants.dart';
import 'package:news_nest/core/network/api_client.dart';
import 'package:news_nest/data/models/news_api_response.dart';

// NewsData.io API Service
class NewsApiService {
  final ApiClient _apiClient;

  NewsApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  // Fetch news articles with pagination support
  Future<NewsApiResponse> fetchNews({
    String? category,
    String? city,
    String? query,
    String? nextPage, // For pagination token
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'language': 'en', // English
        'country': 'in', // India
      };

      // Add pagination
      if (nextPage != null && nextPage.isNotEmpty) {
        queryParams['page'] = nextPage;
      }

      // Add category filter (can be multiple)
      if (category != null && category.isNotEmpty && category != 'All') {
        queryParams['category'] = category.toLowerCase();
      }

      // Add search query
      if (query != null && query.isNotEmpty) {
        queryParams['q'] = query;
      }

      // Add city/state filter as search query
      if (city != null && city.isNotEmpty) {
        final currentQuery = queryParams['q'] as String?;
        queryParams['q'] = currentQuery != null ? '$currentQuery $city' : city;
      }

      debugPrint('Fetching news with params: $queryParams');

      final response = await _apiClient.get(
        ApiConstants.newsEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return NewsApiResponse.fromJson(data);
      }

      throw Exception('Failed to load news');
    } catch (e) {
      debugPrint('Error fetching news: $e');
      rethrow;
    }
  }

  // Fetch local/city news using keyword search with pagination
  Future<NewsApiResponse> fetchLocalNews({
    required String city,
    String? nextPage,
  }) async {
    return fetchNews(query: city, nextPage: nextPage);
  }

  // Search news
  Future<NewsApiResponse> searchNews({required String query}) async {
    return fetchNews(query: query);
  }

  // Fetch trending/top news
  Future<NewsApiResponse> fetchTrendingNews() async {
    return fetchNews(category: 'top');
  }

  // Fetch by AI tag (government, economy, etc.)
  Future<NewsApiResponse> fetchByAiTag({required String tag}) async {
    try {
      final queryParams = <String, dynamic>{
        'language': 'en',
        'country': 'in',
        'ai_tag': tag,
      };

      final response = await _apiClient.get(
        ApiConstants.newsEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return NewsApiResponse.fromJson(data);
      }

      throw Exception('Failed to load news by AI tag');
    } catch (e) {
      debugPrint('Error fetching news by AI tag: $e');
      rethrow;
    }
  }

  // Fetch by AI region
  Future<NewsApiResponse> fetchByAiRegion({required String region}) async {
    try {
      final queryParams = <String, dynamic>{
        'language': 'en',
        'ai_region': region,
      };

      final response = await _apiClient.get(
        ApiConstants.newsEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return NewsApiResponse.fromJson(data);
      }

      throw Exception('Failed to load news by AI region');
    } catch (e) {
      debugPrint('Error fetching news by AI region: $e');
      rethrow;
    }
  }
}
