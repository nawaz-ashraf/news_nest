import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_nest/data/models/loading_state.dart';
import 'package:news_nest/features/home/widgets/news_card_compact.dart';
import 'package:news_nest/providers/news_feed_provider.dart';
import 'package:news_nest/routes/app_router.dart';
import 'package:provider/provider.dart';

/// Related Articles Widget - Shows related articles in the same category
class RelatedArticles extends StatelessWidget {
  final String currentArticleId;
  final String? category;

  const RelatedArticles({
    super.key,
    required this.currentArticleId,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsFeedProvider>(
      builder: (context, provider, _) {
        // Filter out current article and limit to 5 related articles
        final relatedArticles = provider.relatedArticles
            .where((article) => article.id != currentArticleId)
            .take(5)
            .toList();

        // Loading state
        if (provider.state == LoadingState.loading && relatedArticles.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Empty state
        if (relatedArticles.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No related articles found',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }

        // Display related articles
        return Column(
          children: relatedArticles.map((article) {
            return NewsCardCompact(
              article: article,
              onTap: () {
                // Navigate to the new article detail
                context.go(AppRoutes.articlePath(article.id), extra: article);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
