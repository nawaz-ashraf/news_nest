import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_nest/core/constants/app_constants.dart';
import 'package:news_nest/data/models/loading_state.dart';
import 'package:news_nest/features/home/widgets/category_tabs.dart';
import 'package:news_nest/features/home/widgets/news_card.dart';
import 'package:news_nest/providers/local_news_provider.dart';
import 'package:news_nest/providers/news_feed_provider.dart';
import 'package:news_nest/providers/user_preferences_provider.dart';
import 'package:news_nest/routes/app_router.dart';
import 'package:news_nest/shared/widgets/empty_state_widget.dart';
import 'package:news_nest/shared/widgets/error_widget.dart';
import 'package:news_nest/shared/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

/// Home Screen - Main news feed with tabs
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedCategory;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final newsFeedProvider = context.read<NewsFeedProvider>();
    final prefsProvider = context.read<UserPreferencesProvider>();

    // Load For You tab by default
    if (prefsProvider.hasInterests) {
      final firstInterest = prefsProvider.selectedInterests.first;
      _selectedCategory = firstInterest;
      newsFeedProvider.fetchNews(category: firstInterest);
    } else {
      newsFeedProvider.fetchNews();
    }
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;

    final index = _tabController.index;
    final prefsProvider = context.read<UserPreferencesProvider>();

    switch (index) {
      case 0: // For You
        if (prefsProvider.hasInterests) {
          final firstInterest = prefsProvider.selectedInterests.first;
          _selectedCategory = firstInterest;
          context.read<NewsFeedProvider>().fetchNews(category: firstInterest);
        }
        break;
      case 1: // Local
        if (prefsProvider.hasCity) {
          context.read<LocalNewsProvider>().fetchLocalNews(
            city: prefsProvider.selectedCity!,
          );
        }
        break;
      case 2: // Trending
        _selectedCategory = null;
        context.read<NewsFeedProvider>().fetchNews(category: 'top');
        break;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when 80% scrolled
      final currentTab = _tabController.index;

      if (currentTab == 0 || currentTab == 2) {
        // For You or Trending
        final provider = context.read<NewsFeedProvider>();
        if (!provider.isLoadingMore && provider.hasMore) {
          provider.loadMore();
        }
      } else if (currentTab == 1) {
        // Local
        final provider = context.read<LocalNewsProvider>();
        if (!provider.isLoadingMore && provider.hasMore) {
          provider.loadMore();
        }
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.appName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () => context.push(AppRoutes.bookmarks),
            tooltip: 'Bookmarks',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
            tooltip: 'Settings',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'For You'),
            Tab(text: 'Local'),
            Tab(text: 'Trending'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildForYouTab(), _buildLocalTab(), _buildTrendingTab()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.search),
        child: const Icon(Icons.search),
        tooltip: 'Search',
      ),
    );
  }

  Widget _buildForYouTab() {
    return Consumer<UserPreferencesProvider>(
      builder: (context, prefsProvider, _) {
        if (!prefsProvider.hasInterests) {
          return EmptyStateWidget.news(
            onRefresh: () => context.push(AppRoutes.interests),
          );
        }

        return Column(
          children: [
            // Category tabs
            CategoryTabs(
              categories: prefsProvider.selectedInterests,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() => _selectedCategory = category);
                context.read<NewsFeedProvider>().fetchNews(
                  category: category,
                  refresh: true,
                );
              },
            ),
            // News list
            Expanded(child: _buildNewsFeed()),
          ],
        );
      },
    );
  }

  Widget _buildLocalTab() {
    return Consumer2<UserPreferencesProvider, LocalNewsProvider>(
      builder: (context, prefsProvider, localProvider, _) {
        if (!prefsProvider.hasCity) {
          return EmptyStateWidget.localNews(
            onChangeCity: () => context.push(AppRoutes.city),
          );
        }

        return RefreshIndicator(
          onRefresh: () => localProvider.refresh(),
          child: _buildLocalNewsList(localProvider),
        );
      },
    );
  }

  Widget _buildTrendingTab() {
    return _buildNewsFeed();
  }

  Widget _buildNewsFeed() {
    return Consumer<NewsFeedProvider>(
      builder: (context, provider, _) {
        // Loading state
        if (provider.state == LoadingState.loading) {
          return const LoadingWidget(itemCount: 5);
        }

        // Error state
        if (provider.hasError) {
          return AppErrorWidget(
            message: provider.errorMessage ?? 'Failed to load news',
            onRetry: () => provider.refresh(),
          );
        }

        // Empty state
        if (provider.isEmpty) {
          return EmptyStateWidget.news(onRefresh: () => provider.refresh());
        }

        // Success state
        return RefreshIndicator(
          onRefresh: () => provider.refresh(),
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount:
                provider.articles.length + (provider.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.articles.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final article = provider.articles[index];
              return NewsCard(
                article: article,
                onTap: () => context.goToArticle(article),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLocalNewsList(LocalNewsProvider provider) {
    // Loading state
    if (provider.state == LoadingState.loading) {
      return const LoadingWidget(itemCount: 5);
    }

    // Error state
    if (provider.hasError) {
      return AppErrorWidget(
        message: provider.errorMessage ?? 'Failed to load local news',
        onRetry: () => provider.refresh(),
      );
    }

    // Empty state
    if (provider.isEmpty) {
      return EmptyStateWidget.localNews(
        city: provider.currentCity,
        onChangeCity: () => context.push(AppRoutes.city),
      );
    }

    // Success state
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: provider.articles.length + (provider.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == provider.articles.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final article = provider.articles[index];
        return NewsCard(
          article: article,
          onTap: () => context.goToArticle(article),
        );
      },
    );
  }
}
