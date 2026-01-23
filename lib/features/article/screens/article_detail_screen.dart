import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_nest/core/extensions/date_extensions.dart';
import 'package:news_nest/data/models/article_model.dart';
import 'package:news_nest/features/article/widgets/related_articles.dart';
import 'package:news_nest/providers/bookmark_provider.dart';
import 'package:news_nest/providers/news_feed_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Article Detail Screen - Full article view with content and actions
class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollProgress);
    _fetchRelatedArticles();
  }

  void _updateScrollProgress() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll > 0) {
        setState(() {
          _scrollProgress = (currentScroll / maxScroll).clamp(0.0, 1.0);
        });
      }
    }
  }

  Future<void> _fetchRelatedArticles() async {
    if (widget.article.categories.isNotEmpty) {
      final category = widget.article.categories.first;
      await context.read<NewsFeedProvider>().fetchRelatedArticles(category);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [_buildAppBar(context, theme), _buildContent(context, theme)],
      ),
      floatingActionButton: _buildActionButtons(context, theme),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeroImage(context, theme),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: LinearProgressIndicator(
          value: _scrollProgress,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation(theme.colorScheme.secondary),
        ),
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context, ThemeData theme) {
    if (widget.article.imageUrl == null || widget.article.imageUrl!.isEmpty) {
      return Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            size: 80,
            color: theme.colorScheme.outline.withValues(alpha: 0.4),
          ),
        ),
      );
    }

    return Hero(
      tag: 'article-${widget.article.id}',
      child: CachedNetworkImage(
        imageUrl: widget.article.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: Icon(
              Icons.broken_image,
              size: 80,
              color: theme.colorScheme.outline.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              widget.article.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),

            // Metadata
            Row(
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${widget.article.source} · ${widget.article.publishedAt.timeAgo}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),

            // Categories
            if (widget.article.categories.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.article.categories.take(3).map((category) {
                  return Chip(
                    label: Text(category, style: const TextStyle(fontSize: 12)),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // Article content/description
            Text(
              widget.article.description ??
                  widget.article.content ??
                  'No detailed content available for this article.',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 32),

            // Read full article button
            if (widget.article.url != null && widget.article.url!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _openFullArticle,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Read Full Article'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),

            const SizedBox(height: 48),

            // Related articles section
            Text(
              'Related Articles',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            RelatedArticles(
              currentArticleId: widget.article.id,
              category: widget.article.categories.isNotEmpty
                  ? widget.article.categories.first
                  : null,
            ),
            const SizedBox(height: 80), // Space for FABs
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bookmark button
        Selector<BookmarkProvider, bool>(
          selector: (_, provider) => provider.isBookmarked(widget.article.id),
          builder: (context, isBookmarked, _) {
            return FloatingActionButton(
              heroTag: 'bookmark',
              onPressed: () {
                context.read<BookmarkProvider>().toggleBookmark(widget.article);

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
              child: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        // Share button
        FloatingActionButton(
          heroTag: 'share',
          onPressed: _shareArticle,
          child: const Icon(Icons.share),
        ),
      ],
    );
  }

  Future<void> _shareArticle() async {
    final article = widget.article;
    final shareText =
        '''
${article.title}

${article.description ?? ''}

Read more: ${article.url ?? 'URL not available'}

Shared via NewsNest
    '''
            .trim();

    try {
      await Share.share(shareText, subject: article.title);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to share article'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _openFullArticle() async {
    final url = widget.article.url;

    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article URL not available'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch URL');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open article'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
