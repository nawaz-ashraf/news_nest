import 'package:news_nest/data/models/article_model.dart';

/// Response wrapper for paginated news API results
class NewsApiResponse {
  final List<Article> articles;
  final String? nextPage;
  final int? totalResults;

  const NewsApiResponse({
    required this.articles,
    this.nextPage,
    this.totalResults,
  });

  /// Check if there are more pages
  bool get hasMore => nextPage != null;

  /// Is the response empty
  bool get isEmpty => articles.isEmpty;

  /// Create from API JSON response
  factory NewsApiResponse.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List? ?? [];
    return NewsApiResponse(
      articles: results.map((e) => Article.fromJson(e)).toList(),
      nextPage: json['nextPage'],
      totalResults: json['totalResults'],
    );
  }

  /// Empty response
  factory NewsApiResponse.empty() {
    return const NewsApiResponse(articles: [], nextPage: null);
  }
}
