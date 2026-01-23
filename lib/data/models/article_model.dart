import '../../core/extensions/date_extensions.dart';

class Article {
  final String id; // article_id

  final String title;

  final String? description;

  final String? content; // Full content

  final String? imageUrl; // image_url

  final String? videoUrl; // video_url

  final String source; // source_name

  final String? sourceId; // source_id

  final String? sourceUrl; // source_url

  final DateTime publishedAt; // pubDate

  final String? url; // link

  final List<String> categories; // category array

  final List<String>? countries; // country array

  final String language;

  final String? sentiment; // positive | neutral | negative

  final List<String>? aiTags; // ai_tag

  final List<String>? aiRegions; // ai_region

  final List<String>? aiOrgs; // ai_org

  final bool? isDuplicate; // duplicate

  final DateTime? bookmarkedAt; // For local bookmark tracking

  Article({
    required this.id,
    required this.title,
    this.description,
    this.content,
    this.imageUrl,
    this.videoUrl,
    required this.source,
    this.sourceId,
    this.sourceUrl,
    required this.publishedAt,
    this.url,
    required this.categories,
    this.countries,
    required this.language,
    this.sentiment,
    this.aiTags,
    this.aiRegions,
    this.aiOrgs,
    this.isDuplicate,
    this.bookmarkedAt,
  });

  // Time ago helper
  String get timeAgo => publishedAt.timeAgo;

  // Primary category for display
  String get primaryCategory =>
      categories.isNotEmpty ? categories.first : 'general';

  // Bookmarked time ago
  String get bookmarkedTimeAgo {
    if (bookmarkedAt == null) return '';
    return bookmarkedAt!.timeAgo;
  }

  // From JSON (NewsData.io API response)
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['article_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      content: json['content'],
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      source: json['source_name'] ?? json['source_id'] ?? 'Unknown',
      sourceId: json['source_id'],
      sourceUrl: json['source_url'],
      publishedAt: json['pubDate'] != null
          ? DateTime.parse(json['pubDate'])
          : DateTime.now(),
      url: json['link'],
      categories:
          (json['category'] as List?)?.map((e) => e.toString()).toList() ??
          ['general'],
      countries: (json['country'] as List?)?.map((e) => e.toString()).toList(),
      language: json['language'] ?? 'en',
      sentiment: json['sentiment'],
      aiTags: (json['ai_tag'] as List?)?.map((e) => e.toString()).toList(),
      aiRegions: (json['ai_region'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      aiOrgs: (json['ai_org'] as List?)?.map((e) => e.toString()).toList(),
      isDuplicate: json['duplicate'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'article_id': id,
      'title': title,
      'description': description,
      'content': content,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'source_name': source,
      'source_id': sourceId,
      'source_url': sourceUrl,
      'pubDate': publishedAt.toIso8601String(),
      'link': url,
      'category': categories,
      'country': countries,
      'language': language,
      'sentiment': sentiment,
      'ai_tag': aiTags,
      'ai_region': aiRegions,
      'ai_org': aiOrgs,
      'duplicate': isDuplicate,
    };
  }

  // CopyWith for updating fields
  Article copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? imageUrl,
    String? videoUrl,
    String? source,
    String? sourceId,
    String? sourceUrl,
    DateTime? publishedAt,
    String? url,
    List<String>? categories,
    List<String>? countries,
    String? language,
    String? sentiment,
    List<String>? aiTags,
    List<String>? aiRegions,
    List<String>? aiOrgs,
    bool? isDuplicate,
    DateTime? bookmarkedAt,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      url: url ?? this.url,
      categories: categories ?? this.categories,
      countries: countries ?? this.countries,
      language: language ?? this.language,
      sentiment: sentiment ?? this.sentiment,
      aiTags: aiTags ?? this.aiTags,
      aiRegions: aiRegions ?? this.aiRegions,
      aiOrgs: aiOrgs ?? this.aiOrgs,
      isDuplicate: isDuplicate ?? this.isDuplicate,
      bookmarkedAt: bookmarkedAt ?? this.bookmarkedAt,
    );
  }

  @override
  String toString() {
    return 'Article(id: $id, title: $title, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Article && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
