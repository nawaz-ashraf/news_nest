import 'package:flutter/material.dart';

// News Categories with Pinterest-style UI labels
enum NewsCategory {
  all,
  business,
  technology,
  politics,
  world,
  sports,
  entertainment,
  science,
  health,
  environment,
  tourism,
  education,
  crime,
  food,
  energy,
  automobile,
  startup,
  fashion,
  realestate,
  top,
}

extension NewsCategoryExtension on NewsCategory {
  // Pinterest-style UI labels with emojis
  String get displayName {
    switch (this) {
      case NewsCategory.all:
        return 'All';
      case NewsCategory.business:
        return '📈 Finance';
      case NewsCategory.technology:
        return '🤖 Technology';
      case NewsCategory.politics:
        return '🏛 Politics';
      case NewsCategory.world:
        return '🌍 World';
      case NewsCategory.sports:
        return '🏏 Sports';
      case NewsCategory.entertainment:
        return '🎬 Entertainment';
      case NewsCategory.science:
        return '🧬 Science';
      case NewsCategory.health:
        return '🩺 Health';
      case NewsCategory.environment:
        return '🌱 Environment';
      case NewsCategory.tourism:
        return '✈️ Tourism';
      case NewsCategory.education:
        return '📚 Education';
      case NewsCategory.crime:
        return '⚖️ Crime';
      case NewsCategory.food:
        return '🍔 Food';
      case NewsCategory.energy:
        return '⚡ Energy';
      case NewsCategory.automobile:
        return '🚗 Automobile';
      case NewsCategory.startup:
        return '🚀 Startups';
      case NewsCategory.fashion:
        return '👗 Fashion';
      case NewsCategory.realestate:
        return '🏠 Real Estate';
      case NewsCategory.top:
        return '🔥 Top Stories';
    }
  }

  // API query strings (NewsData.io format)
  String get apiValue {
    switch (this) {
      case NewsCategory.all:
        return '';
      case NewsCategory.business:
        return 'business';
      case NewsCategory.technology:
        return 'technology';
      case NewsCategory.politics:
        return 'politics';
      case NewsCategory.world:
        return 'world';
      case NewsCategory.sports:
        return 'sports';
      case NewsCategory.entertainment:
        return 'entertainment';
      case NewsCategory.science:
        return 'science';
      case NewsCategory.health:
        return 'health';
      case NewsCategory.environment:
        return 'environment';
      case NewsCategory.tourism:
        return 'tourism';
      case NewsCategory.education:
        return 'education';
      case NewsCategory.crime:
        return 'crime';
      case NewsCategory.food:
        return 'food';
      case NewsCategory.energy:
        return 'energy';
      case NewsCategory.automobile:
        return 'automobile';
      case NewsCategory.startup:
        return 'startup';
      case NewsCategory.fashion:
        return 'fashion';
      case NewsCategory.realestate:
        return 'realestate';
      case NewsCategory.top:
        return 'top';
    }
  }

  // Icons for each category
  IconData get icon {
    switch (this) {
      case NewsCategory.all:
        return Icons.dashboard;
      case NewsCategory.business:
        return Icons.trending_up;
      case NewsCategory.technology:
        return Icons.computer;
      case NewsCategory.politics:
        return Icons.account_balance;
      case NewsCategory.world:
        return Icons.public;
      case NewsCategory.sports:
        return Icons.sports_cricket;
      case NewsCategory.entertainment:
        return Icons.movie;
      case NewsCategory.science:
        return Icons.science;
      case NewsCategory.health:
        return Icons.health_and_safety;
      case NewsCategory.environment:
        return Icons.eco;
      case NewsCategory.tourism:
        return Icons.flight;
      case NewsCategory.education:
        return Icons.school;
      case NewsCategory.crime:
        return Icons.gavel;
      case NewsCategory.food:
        return Icons.restaurant;
      case NewsCategory.energy:
        return Icons.electric_bolt;
      case NewsCategory.automobile:
        return Icons.directions_car;
      case NewsCategory.startup:
        return Icons.rocket_launch;
      case NewsCategory.fashion:
        return Icons.checkroom;
      case NewsCategory.realestate:
        return Icons.home;
      case NewsCategory.top:
        return Icons.whatshot;
    }
  }
}

// Helper class for category operations
class Categories {
  // Pinterest-style selectable categories for onboarding
  static List<NewsCategory> get pinterestSelectable {
    return [
      NewsCategory.business,
      NewsCategory.technology,
      NewsCategory.politics,
      NewsCategory.world,
      NewsCategory.sports,
      NewsCategory.entertainment,
      NewsCategory.science,
      NewsCategory.health,
      NewsCategory.environment,
    ];
  }

  // All selectable categories (excluding 'All')
  static List<NewsCategory> get selectable {
    return NewsCategory.values.where((c) => c != NewsCategory.all).toList();
  }

  // All categories including 'All'
  static List<NewsCategory> get all {
    return NewsCategory.values;
  }

  // Get category from string
  static NewsCategory fromString(String value) {
    return NewsCategory.values.firstWhere(
      (category) =>
          category.displayName.toLowerCase() == value.toLowerCase() ||
          category.apiValue.toLowerCase() == value.toLowerCase(),
      orElse: () => NewsCategory.all,
    );
  }

  // Get display names for Pinterest categories
  static List<String> get pinterestDisplayNames {
    return pinterestSelectable.map((c) => c.displayName).toList();
  }
}

/// Category class for UI display with styling
class Category {
  final String id;
  final String displayName;
  final String emoji;
  final Color color;

  const Category({
    required this.id,
    required this.displayName,
    required this.emoji,
    required this.color,
  });
}

/// App Categories for interest selection in onboarding
class AppCategories {
  static const List<Category> all = [
    Category(
      id: 'business',
      displayName: 'Finance',
      emoji: '📈',
      color: Color(0xFF10B981),
    ),
    Category(
      id: 'technology',
      displayName: 'Technology',
      emoji: '🤖',
      color: Color(0xFF6366F1),
    ),
    Category(
      id: 'politics',
      displayName: 'Politics',
      emoji: '🏛',
      color: Color(0xFF8B5CF6),
    ),
    Category(
      id: 'world',
      displayName: 'World',
      emoji: '🌍',
      color: Color(0xFF3B82F6),
    ),
    Category(
      id: 'sports',
      displayName: 'Sports',
      emoji: '🏏',
      color: Color(0xFFF59E0B),
    ),
    Category(
      id: 'entertainment',
      displayName: 'Entertainment',
      emoji: '🎬',
      color: Color(0xFFEC4899),
    ),
    Category(
      id: 'science',
      displayName: 'Science',
      emoji: '🧬',
      color: Color(0xFF14B8A6),
    ),
    Category(
      id: 'health',
      displayName: 'Health',
      emoji: '🩺',
      color: Color(0xFFEF4444),
    ),
    Category(
      id: 'environment',
      displayName: 'Environment',
      emoji: '🌱',
      color: Color(0xFF22C55E),
    ),
    Category(
      id: 'tourism',
      displayName: 'Tourism',
      emoji: '✈️',
      color: Color(0xFF0EA5E9),
    ),
    Category(
      id: 'education',
      displayName: 'Education',
      emoji: '📚',
      color: Color(0xFFA855F7),
    ),
    Category(
      id: 'crime',
      displayName: 'Crime',
      emoji: '⚖️',
      color: Color(0xFF64748B),
    ),
    Category(
      id: 'food',
      displayName: 'Food',
      emoji: '🍔',
      color: Color(0xFFF97316),
    ),
    Category(
      id: 'automobile',
      displayName: 'Automobile',
      emoji: '🚗',
      color: Color(0xFF0891B2),
    ),
    Category(
      id: 'startup',
      displayName: 'Startups',
      emoji: '🚀',
      color: Color(0xFFD946EF),
    ),
    Category(
      id: 'fashion',
      displayName: 'Fashion',
      emoji: '👗',
      color: Color(0xFFF472B6),
    ),
  ];
}
