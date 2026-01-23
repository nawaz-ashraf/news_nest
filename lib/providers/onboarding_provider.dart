import 'package:flutter/foundation.dart';
import 'package:news_nest/core/constants/app_constants.dart';
import 'package:news_nest/data/repositories/preferences_repository.dart';

/// OnboardingProvider manages the onboarding flow state
class OnboardingProvider extends ChangeNotifier {
  final PreferencesRepository _repository;

  OnboardingProvider({PreferencesRepository? repository})
    : _repository = repository ?? PreferencesRepository();

  // State
  bool _isOnboardingComplete = false;
  int _currentStep = 0; // 0: Welcome, 1: Interests, 2: City, 3: Complete
  List<String> _selectedInterests = [];
  String? _selectedCity;

  // Getters
  bool get isOnboardingComplete => _isOnboardingComplete;
  int get currentStep => _currentStep;
  List<String> get selectedInterests => List.unmodifiable(_selectedInterests);
  String? get selectedCity => _selectedCity;
  int get totalSteps => 4; // Welcome, Interests, City, Complete
  double get progress => (_currentStep + 1) / totalSteps;

  // Validation
  bool get canProceedFromInterests =>
      _selectedInterests.length >= AppConstants.minInterests;
  bool get canProceedFromCity =>
      _selectedCity != null && _selectedCity!.isNotEmpty;

  /// Check if onboarding was completed before
  Future<void> checkOnboardingStatus() async {
    _isOnboardingComplete = await _repository.isOnboardingComplete();
    notifyListeners();
  }

  /// Go to next step
  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  /// Go to previous step
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  /// Go to specific step
  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      _currentStep = step;
      notifyListeners();
    }
  }

  /// Toggle interest selection
  void toggleInterest(String interest) {
    if (_selectedInterests.contains(interest)) {
      _selectedInterests.remove(interest);
    } else if (_selectedInterests.length < AppConstants.maxInterests) {
      _selectedInterests.add(interest);
    }
    notifyListeners();
  }

  /// Check if interest is selected
  bool isInterestSelected(String interest) {
    return _selectedInterests.contains(interest);
  }

  /// Set selected city
  void setCity(String city) {
    _selectedCity = city;
    notifyListeners();
  }

  /// Complete onboarding and save preferences
  Future<void> completeOnboarding() async {
    try {
      // Save interests
      await _repository.saveSelectedInterests(_selectedInterests);

      // Save city if selected
      if (_selectedCity != null) {
        await _repository.saveSelectedCity(_selectedCity!);
      }

      // Mark onboarding as complete
      await _repository.setOnboardingComplete(true);
      _isOnboardingComplete = true;

      notifyListeners();
    } catch (e) {
      debugPrint('Error completing onboarding: $e');
      rethrow;
    }
  }

  /// Reset onboarding (for testing or re-onboarding)
  Future<void> resetOnboarding() async {
    _currentStep = 0;
    _selectedInterests.clear();
    _selectedCity = null;
    _isOnboardingComplete = false;
    await _repository.setOnboardingComplete(false);
    notifyListeners();
  }
}
