import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_nest/core/extensions/date_extensions.dart';
import 'package:news_nest/data/models/article_model.dart';
import 'package:news_nest/providers/bookmark_provider.dart';
import 'package:provider/provider.dart';

/// News Card Widget - Full card with image for main feed
class NewsCard extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;

  const NewsCard({super.key, required this.article, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildImage(context), _buildContent(context)],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final theme = Theme.of(context);

    if (article.imageUrl == null || article.imageUrl!.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            size: 64,
            color: theme.colorScheme.outline.withValues(alpha: 0.4),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: CachedNetworkImage(
        imageUrl: article.imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        memCacheWidth: 600, // Optimize memory
        placeholder: (context, url) => Container(
          height: 200,
          color: theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 200,
          color: theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: Icon(
              Icons.broken_image,
              size: 64,
              color: theme.colorScheme.outline.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            article.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (article.description != null &&
              article.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              article.description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          // Footer
          Row(
            children: [
              // Source and time
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        article.source,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      ' · ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      article.publishedAt.timeAgo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Bookmark button
              Selector<BookmarkProvider, bool>(
                selector: (_, provider) => provider.isBookmarked(article.id),
                builder: (context, isBookmarked, _) {
                  return IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      context.read<BookmarkProvider>().toggleBookmark(article);

                      // Show snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isBookmarked
                                ? 'Removed from bookmarks'
                                : 'Added to bookmarks',
                          ),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    visualDensity: VisualDensity.compact,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
