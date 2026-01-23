import 'package:hive/hive.dart';

part 'user_preferences_model.g.dart';

@HiveType(typeId: 1)
class UserPreferences {
  @HiveField(0)
  final bool onboardingComplete;

  @HiveField(1)
  final List<String> selectedInterests;

  @HiveField(2)
  final String? selectedCity;

  @HiveField(3)
  final String themeMode; // 'light', 'dark', 'system'

  @HiveField(4)
  final DateTime lastUpdated;

  UserPreferences({
    required this.onboardingComplete,
    required this.selectedInterests,
    this.selectedCity,
    this.themeMode = 'system',
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  // Factory for initial/default preferences
  factory UserPreferences.initial() {
    return UserPreferences(
      onboardingComplete: false,
      selectedInterests: [],
      selectedCity: null,
      themeMode: 'system',
    );
  }

  // From JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      onboardingComplete: json['onboarding_complete'] ?? false,
      selectedInterests: List<String>.from(json['selected_interests'] ?? []),
      selectedCity: json['selected_city'],
      themeMode: json['theme_mode'] ?? 'system',
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'onboarding_complete': onboardingComplete,
      'selected_interests': selectedInterests,
      'selected_city': selectedCity,
      'theme_mode': themeMode,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  // CopyWith
  UserPreferences copyWith({
    bool? onboardingComplete,
    List<String>? selectedInterests,
    String? selectedCity,
    String? themeMode,
    DateTime? lastUpdated,
  }) {
    return UserPreferences(
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      selectedCity: selectedCity ?? this.selectedCity,
      themeMode: themeMode ?? this.themeMode,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'UserPreferences(onboardingComplete: $onboardingComplete, interests: ${selectedInterests.length}, city: $selectedCity)';
  }
}
