import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_nest/data/models/loading_state.dart';
import 'package:news_nest/features/home/widgets/news_card_compact.dart';
import 'package:news_nest/providers/search_provider.dart';
import 'package:news_nest/routes/app_router.dart';
import 'package:news_nest/shared/widgets/empty_state_widget.dart';
import 'package:news_nest/shared/widgets/error_widget.dart';
import 'package:news_nest/shared/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

/// Search Screen - Search for news articles
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
      context.read<SearchProvider>().loadRecentSearches();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    context.read<SearchProvider>().search(query.trim());
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
          style: theme.textTheme.titleMedium,
          textInputAction: TextInputAction.search,
          onSubmitted: _performSearch,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                context.read<SearchProvider>().clearResults();
                _searchFocusNode.requestFocus();
              },
            ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _performSearch(_searchController.text),
          ),
        ],
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, _) {
          // Show recent searches when not searching
          if (provider.state == LoadingState.initial &&
              provider.results.isEmpty) {
            return _buildRecentSearches(context, provider);
          }

          // Loading state
          if (provider.state == LoadingState.loading) {
            return const LoadingWidget(itemCount: 8);
          }

          // Error state
          if (provider.hasError) {
            return AppErrorWidget(
              message: provider.errorMessage ?? 'Failed to search',
              onRetry: () => _performSearch(_searchController.text),
            );
          }

          // Empty state
          if (provider.results.isEmpty && _searchController.text.isNotEmpty) {
            return EmptyStateWidget.search(query: _searchController.text);
          }

          // Results
          return ListView.builder(
            itemCount: provider.results.length,
            padding: const EdgeInsets.only(bottom: 16),
            itemBuilder: (context, index) {
              final article = provider.results[index];
              return NewsCardCompact(
                article: article,
                onTap: () => context.goToArticle(article),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRecentSearches(BuildContext context, SearchProvider provider) {
    if (provider.recentSearches.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search,
        message: 'Search for news',
        subtitle: 'Find articles by topic, source, or keyword',
      );
    }

    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                provider.clearHistory();
              },
              child: const Text('Clear all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...provider.recentSearches.map((query) {
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(query),
            trailing: IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () {
                provider.removeFromHistory(query);
              },
            ),
            onTap: () {
              _searchController.text = query;
              _performSearch(query);
            },
          );
        }),
      ],
    );
  }
}
