# 🎯 Onboarding Feature - Agent Instructions

## Feature Overview
The Onboarding feature guides first-time users through a personalized setup experience where they select their interests (3-15 topics) and choose their city. This feature implements a Pinterest-style visual interest selector and a searchable city picker.

## Files in This Feature

| File | Purpose |
|------|---------|
| `screens/welcome_screen.dart` | Welcome/intro screen with app benefits |
| `screens/interest_picker_screen.dart` | Pinterest-style interest selection |
| `screens/city_selector_screen.dart` | City selection with search |
| `screens/onboarding_complete_screen.dart` | Completion confirmation |
| `widgets/interest_tile.dart` | Selectable interest tile widget |
| `widgets/city_tile.dart` | Selectable city tile widget |

## State Management
- Uses `OnboardingProvider` to track:
  - Selected interests (List<String>)
  - Selected city (String?)
  - Current onboarding step (int)
  - Validation state (bool)

## User Journey Flow
```
Welcome → Interest Picker → City Selector → Completion → Home
```

---

## 1. Welcome Screen

### Acceptance Criteria
- ✅ Display app logo and name
- ✅ Show 3-4 key benefits with icons
- ✅ Single "Get Started" button at bottom
- ✅ Smooth page transitions with animations

### UI Specifications
| Element | Details |
|---------|---------|
| Logo | Centered, 100x100 dp |
| Headline | "Welcome to NewsNest" - Display Large |
| Benefits List | Icons + Text, vertically stacked |
| CTA Button | Full width, 56 dp height |

### Sample Benefits Text
- 📰 "Personalized news just for you"
- 📍 "Hyperlocal updates from your city"
- ⚡ "Fast, clean reading experience"
- 🔖 "Save and read offline"

### Navigation
```dart
// On button tap
context.go('/interests');
```

---

## 2. Interest Picker Screen

### Acceptance Criteria
- ✅ Display all available interests as tiles (from categories.dart)
- ✅ Grid layout, 2 columns, responsive spacing
- ✅ Minimum 3 interests required
- ✅ Maximum 15 interests allowed
- ✅ Visual feedback on selection (border, checkmark, color)
- ✅ Counter showing "X/15 selected"
- ✅ "Continue" button enabled only when ≥3 selected
- ✅ Smooth selection animations

### UI Specifications
| Element | Details |
|---------|---------|
| AppBar | "Choose Your Interests" + Skip button |
| Grid | 2 columns, 16dp gap |
| Tile Size | ~160x100 dp |
| Selection Indicator | Checkmark icon + accent border |
| Bottom Bar | Counter + Continue button |

### Interest Tile Widget Spec
```dart
class InterestTile extends StatelessWidget {
  final String interest;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  // Shows:
  // - Icon (32x32)
  // - Interest name
  // - If selected: checkmark + accent color border
  // - Tap animation (scale 0.95)
}
```

### State Update Pattern
```dart
// In interest_picker_screen.dart
Consumer<OnboardingProvider>(
  builder: (context, provider, _) {
    return GridView.builder(
      itemCount: interests.length,
      itemBuilder: (context, index) {
        final interest = interests[index];
        final isSelected = provider.selectedInterests.contains(interest);
        
        return InterestTile(
          interest: interest,
          isSelected: isSelected,
          onTap: () => provider.toggleInterest(interest),
        );
      },
    );
  },
)
```

### Validation Logic
```dart
// In OnboardingProvider
bool get canProceedFromInterests =>
    selectedInterests.length >= 3 && selectedInterests.length <= 15;
```

### Navigation
```dart
// On Continue button tap
if (provider.canProceedFromInterests) {
  context.go('/city');
}
```

---

## 3. City Selector Screen

### Acceptance Criteria
- ✅ Display popular cities (Delhi, Bangalore, Mumbai, etc.)
- ✅ Search bar to filter cities
- ✅ Single selection (radio-like behavior)
- ✅ "Continue" button enabled only after selection
- ✅ Smooth transitions

### UI Specifications
| Element | Details |
|---------|---------|
| AppBar | "Select Your City" |
| Search Bar | TextField with search icon |
| Popular Cities | Chip-style tiles, 2 columns |
| Other Cities | Expandable list |
| CTA Button | "Continue" at bottom |

### City Data Source
```dart
// From lib/core/constants/cities.dart
class IndianCities {
  static const List<String> popular = [
    'Delhi NCR',
    'Bangalore',
    'Mumbai',
    'Hyderabad',
    'Kolkata',
    'Chennai',
    'Pune',
  ];
  
  static const List<String> all = [...popular, ...others];
}
```

### City Tile Widget Spec
```dart
class CityTile extends StatelessWidget {
  final String city;
  final bool isSelected;
  final VoidCallback onTap;

  // Shows:
  // - City name
  // - Location icon
  // - If selected: filled background with checkmark
  // - Tap animation
}
```

### Search Implementation
```dart
// In city_selector_screen.dart
List<String> _filteredCities = [];

void _filterCities(String query) {
  setState(() {
    if (query.isEmpty) {
      _filteredCities = IndianCities.all;
    } else {
      _filteredCities = IndianCities.all
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  });
}
```

### State Update
```dart
// In OnboardingProvider
void selectCity(String city) {
  _selectedCity = city;
  notifyListeners();
}

bool get canProceedFromCity => _selectedCity != null;
```

### Navigation
```dart
// On Continue button tap
if (provider.canProceedFromCity) {
  context.go('/onboarding-complete');
}
```

---

## 4. Onboarding Complete Screen

### Acceptance Criteria
- ✅ Show success message
- ✅ Display Lottie animation (checkmark/celebration)
- ✅ Summary of selections (interests + city)
- ✅ "Explore NewsNest" button
- ✅ Save preferences to local storage
- ✅ Mark onboarding as complete

### UI Specifications
| Element | Details |
|---------|---------|
| Animation | Lottie success animation (200x200) |
| Headline | "All Set!" |
| Summary | Chips showing selected interests + city |
| CTA Button | "Explore NewsNest" |

### Save Preferences Logic
```dart
// In onboarding_complete_screen.dart
Future<void> _completeOnboarding() async {
  final provider = context.read<OnboardingProvider>();
  final prefsProvider = context.read<UserPreferencesProvider>();
  
  await prefsProvider.saveInterests(provider.selectedInterests);
  await prefsProvider.saveCity(provider.selectedCity!);
  await prefsProvider.markOnboardingComplete();
  
  if (!mounted) return;
  context.go('/home');
}
```

### Animation
```dart
// Using lottie package
Lottie.asset(
  'assets/animations/success.json',
  width: 200,
  height: 200,
  repeat: false,
)
```

---

## OnboardingProvider Implementation

### Provider Structure
```dart
class OnboardingProvider extends ChangeNotifier {
  List<String> _selectedInterests = [];
  String? _selectedCity;
  int _currentStep = 0;

  List<String> get selectedInterests => List.unmodifiable(_selectedInterests);
  String? get selectedCity => _selectedCity;
  int get currentStep => _currentStep;

  // Validation getters
  bool get canProceedFromInterests =>
      _selectedInterests.length >= 3 && _selectedInterests.length <= 15;
  
  bool get canProceedFromCity => _selectedCity != null;

  // Methods
  void toggleInterest(String interest) {
    if (_selectedInterests.contains(interest)) {
      _selectedInterests.remove(interest);
    } else {
      if (_selectedInterests.length < 15) {
        _selectedInterests.add(interest);
      }
    }
    notifyListeners();
  }

  void selectCity(String city) {
    _selectedCity = city;
    notifyListeners();
  }

  void nextStep() {
    _currentStep++;
    notifyListeners();
  }

  void reset() {
    _selectedInterests.clear();
    _selectedCity = null;
    _currentStep = 0;
    notifyListeners();
  }
}
```

---

## Routing Configuration

```dart
// In lib/routes/app_router.dart
GoRoute(
  path: '/welcome',
  name: 'welcome',
  builder: (context, state) => const WelcomeScreen(),
),
GoRoute(
  path: '/interests',
  name: 'interests',
  builder: (context, state) => const InterestPickerScreen(),
),
GoRoute(
  path: '/city',
  name: 'city',
  builder: (context, state) => const CitySelectorScreen(),
),
GoRoute(
  path: '/onboarding-complete',
  name: 'onboarding-complete',
  builder: (context, state) => const OnboardingCompleteScreen(),
),
```

---

## Animation Recommendations

### Page Transitions
```dart
// Use flutter_animate for smooth transitions
child.animate()
  .fadeIn(duration: 300.ms)
  .slideX(begin: 0.2, end: 0);
```

### Interest Tile Selection
```dart
// Scale effect on tap
.animate(target: isSelected ? 1 : 0)
  .scale(duration: 200.ms, curve: Curves.easeOut);
```

---

## Testing Checklist
- [ ] Can select 3-15 interests (not less, not more)
- [ ] Visual feedback on interest selection
- [ ] Search filters cities correctly
- [ ] Can select only one city
- [ ] Continue buttons properly enabled/disabled
- [ ] Back navigation works correctly
- [ ] Preferences saved to local storage
- [ ] Navigates to home after completion
- [ ] Works in both light and dark mode

---

## Common Pitfalls
- ❌ Don't allow < 3 or > 15 interest selections
- ❌ Don't forget to persist preferences
- ❌ Don't use setState with Provider (use Provider only)
- ✅ Always validate before navigation
- ✅ Use `!mounted` checks before async navigation
- ✅ Dispose controllers in StatefulWidgets

---

## Assets Required
- `assets/animations/success.json` (Lottie animation)
- Interest icons (use Material Icons)
- City location icon (Icons.location_city)

---

**Priority**: P0 (Must Have)
**Complexity**: Medium-High
**Estimated Time**: 4-5 hours
**Dependencies**: 
- OnboardingProvider
- UserPreferencesProvider
- categories.dart
- cities.dart
