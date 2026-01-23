import 'package:flutter/foundation.dart';
import 'package:news_nest/data/repositories/preferences_repository.dart';

/// UserPreferencesProvider manages user settings like interests, city, etc.
class UserPreferencesProvider extends ChangeNotifier {
  final PreferencesRepository _repository;

  UserPreferencesProvider({PreferencesRepository? repository})
    : _repository = repository ?? PreferencesRepository();

  // State
  List<String> _selectedInterests = [];
  String? _selectedCity;
  bool _isLoading = false;

  // Getters
  List<String> get selectedInterests => List.unmodifiable(_selectedInterests);
  String? get selectedCity => _selectedCity;
  bool get isLoading => _isLoading;
  bool get hasInterests => _selectedInterests.isNotEmpty;
  bool get hasCity => _selectedCity != null && _selectedCity!.isNotEmpty;

  /// Load user preferences from local storage
  Future<void> loadPreferences() async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedInterests = await _repository.getSelectedInterests();
      _selectedCity = await _repository.getSelectedCity();
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update selected interests
  Future<void> setInterests(List<String> interests) async {
    _selectedInterests = List.from(interests);
    notifyListeners();
    await _repository.saveSelectedInterests(interests);
  }

  /// Add a single interest
  Future<void> addInterest(String interest) async {
    if (!_selectedInterests.contains(interest)) {
      _selectedInterests.add(interest);
      notifyListeners();
      await _repository.saveSelectedInterests(_selectedInterests);
    }
  }

  /// Remove a single interest
  Future<void> removeInterest(String interest) async {
    if (_selectedInterests.contains(interest)) {
      _selectedInterests.remove(interest);
      notifyListeners();
      await _repository.saveSelectedInterests(_selectedInterests);
    }
  }

  /// Toggle an interest (add if not present, remove if present)
  Future<void> toggleInterest(String interest) async {
    if (_selectedInterests.contains(interest)) {
      await removeInterest(interest);
    } else {
      await addInterest(interest);
    }
  }

  /// Update selected city
  Future<void> setCity(String city) async {
    _selectedCity = city;
    notifyListeners();
    await _repository.saveSelectedCity(city);
  }

  /// Clear selected city
  Future<void> clearCity() async {
    _selectedCity = null;
    notifyListeners();
    await _repository.saveSelectedCity('');
  }

  /// Check if a specific interest is selected
  bool isInterestSelected(String interest) {
    return _selectedInterests.contains(interest);
  }
}
