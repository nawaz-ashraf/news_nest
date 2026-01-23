import 'package:flutter/material.dart';

/// Widget to display when content is empty
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData icon;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  /// Factory for empty bookmarks
  factory EmptyStateWidget.bookmarks({VoidCallback? onExplore}) {
    return EmptyStateWidget(
      message: 'No Bookmarks Yet',
      subtitle: 'Save articles to read them offline',
      icon: Icons.bookmark_border,
      action: onExplore != null
          ? TextButton.icon(
              onPressed: onExplore,
              icon: const Icon(Icons.explore),
              label: const Text('Explore News'),
            )
          : null,
    );
  }

  /// Factory for empty search results
  factory EmptyStateWidget.search({String? query}) {
    return EmptyStateWidget(
      message: 'No Results Found',
      subtitle: query != null
          ? 'No articles found for "$query"'
          : 'Try different keywords',
      icon: Icons.search_off,
    );
  }

  /// Factory for empty news feed
  factory EmptyStateWidget.news({VoidCallback? onRefresh}) {
    return EmptyStateWidget(
      message: 'No Articles Available',
      subtitle: 'Check back later for new content',
      icon: Icons.article_outlined,
      action: onRefresh != null
          ? TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            )
          : null,
    );
  }

  /// Factory for empty local news
  factory EmptyStateWidget.localNews({
    String? city,
    VoidCallback? onChangeCity,
  }) {
    return EmptyStateWidget(
      message: 'No Local News',
      subtitle: city != null
          ? 'No news available for $city'
          : 'Select a city to see local news',
      icon: Icons.location_city,
      action: onChangeCity != null
          ? TextButton.icon(
              onPressed: onChangeCity,
              icon: const Icon(Icons.edit_location),
              label: const Text('Change City'),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}
