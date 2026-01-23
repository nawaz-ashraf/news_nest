import 'package:flutter/material.dart';
import 'package:news_nest/data/models/article_model.dart';
import 'package:news_nest/features/home/widgets/news_card.dart';
import 'package:news_nest/providers/bookmark_provider.dart';
import 'package:news_nest/routes/app_router.dart';
import 'package:news_nest/shared/widgets/empty_state_widget.dart';
import 'package:provider/provider.dart';

/// Bookmarks Screen - Display saved articles

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookmarkProvider>().loadBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Selector<BookmarkProvider, int>(
        selector: (_, provider) => provider.bookmarks.length,
        builder: (context, count, _) {
          return Text('Bookmarks ($count)');
        },
      ),
      actions: [
        Selector<BookmarkProvider, bool>(
          selector: (_, provider) => provider.bookmarks.isNotEmpty,
          builder: (context, hasBookmarks, _) {
            if (!hasBookmarks) return const SizedBox.shrink();

            return PopupMenuButton<String>(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline),
                      SizedBox(width: 8),
                      Text('Remove all'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'clear') {
                  _confirmClearAll(context);
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<BookmarkProvider>(
      builder: (context, provider, _) {
        // Empty state
        if (provider.bookmarks.isEmpty) {
          return EmptyStateWidget.bookmarks();
        }

        // Bookmarks list with dismissible
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: provider.bookmarks.length,
          itemBuilder: (context, index) {
            final article = provider.bookmarks[index];

            return Dismissible(
              key: Key(article.id),
              direction: DismissDirection.endToStart,
              background: _buildDismissBackground(context),
              confirmDismiss: (direction) async {
                return await _confirmRemove(context, article);
              },
              onDismissed: (_) {
                provider.removeBookmark(article);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Bookmark removed'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        provider.addBookmark(article);
                      },
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: NewsCard(
                article: article,
                onTap: () => context.goToArticle(article),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDismissBackground(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Icon(
        Icons.delete_outline,
        color: theme.colorScheme.onErrorContainer,
        size: 28,
      ),
    );
  }

  Future<bool> _confirmRemove(BuildContext context, Article article) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove bookmark?'),
        content: Text('Remove "${article.title}" from bookmarks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _confirmClearAll(BuildContext context) async {
    final provider = context.read<BookmarkProvider>();
    final count = provider.bookmarks.length;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove all bookmarks?'),
        content: Text('This will remove all $count bookmarked articles.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove All'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      provider.clearAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All bookmarks removed'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
