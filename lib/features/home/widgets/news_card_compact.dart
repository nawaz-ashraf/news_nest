import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_nest/core/extensions/date_extensions.dart';
import 'package:news_nest/data/models/article_model.dart';
import 'package:news_nest/providers/bookmark_provider.dart';
import 'package:provider/provider.dart';

/// News Card Compact - Horizontal layout for trending/search
class NewsCardCompact extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;

  const NewsCardCompact({super.key, required this.article, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(context),
              const SizedBox(width: 12),
              Expanded(child: _buildContent(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final theme = Theme.of(context);

    if (article.imageUrl == null || article.imageUrl!.isEmpty) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.image_not_supported,
          size: 32,
          color: theme.colorScheme.outline.withValues(alpha: 0.4),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: article.imageUrl!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        memCacheWidth: 200,
        placeholder: (context, url) => Container(
          width: 80,
          height: 80,
          color: theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 80,
          height: 80,
          color: theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.broken_image,
            size: 32,
            color: theme.colorScheme.outline.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          article.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        // Footer
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      article.source,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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
                    size: 20,
                    color: isBookmarked
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    context.read<BookmarkProvider>().toggleBookmark(article);
                  },
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
