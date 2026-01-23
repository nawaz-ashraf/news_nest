# 🚀 Splash Screen - Agent Instructions

## Feature Overview
The Splash Screen is the first screen users see when launching NewsNest. It displays the app logo with an animation while initializing local storage, checking user preferences, and determining the next navigation destination.

## File Location
`lib/features/splash/screens/splash_screen.dart`

## Acceptance Criteria

### Functional Requirements
- ✅ Display app logo centered on screen
- ✅ Show smooth logo animation (fade in + scale)
- ✅ Duration: 2-3 seconds
- ✅ Initialize Hive boxes during splash
- ✅ Check if user completed onboarding
- ✅ Navigate to appropriate screen:
  - If onboarding incomplete → `/welcome`
  - If onboarding complete → `/home`

### Technical Requirements
- ✅ Use StatefulWidget with initState
- ✅ Use Future.delayed for minimum splash duration
- ✅ Use AnimatedOpacity or flutter_animate
- ✅ No user interaction during splash (no taps)
- ✅ Handle initialization errors gracefully

### UI Specifications

| Element | Specification |
|---------|--------------|
| Background | Gradient (depends on theme) |
| Logo Size | 120x120 dp |
| Animation | Fade in (0→1) + Scale (0.8→1.0) |
| Duration | 400ms for animation, 2.5s total |
| Status Bar | Transparent |

## Implementation Pattern

### Suggested Structure
```dart
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // 1. Initialize Hive
    // 2. Check onboarding status
    // 3. Wait minimum duration
    // 4. Navigate to next screen
  }

  @override
  Widget build(BuildContext context) {
    // Return Scaffold with gradient background and animated logo
  }
}
```

### Dependencies
```yaml
# Already in pubspec
flutter_animate: ^4.5.0
```

### State Management
- ✅ Read from `UserPreferencesProvider` (use `context.read()`)
- ✅ Check `isOnboardingComplete` property
- ❌ Don't use Consumer/watch (no rebuilds needed)

## Navigation

### Route Definition (in app_router.dart)
```dart
GoRoute(
  path: '/',
  name: 'splash',
  builder: (context, state) => const SplashScreen(),
),
```

### Navigation Logic
```dart
if (isOnboardingComplete) {
  context.go('/home');
} else {
  context.go('/welcome');
}
```

## Error Handling
- If Hive initialization fails → Show error dialog with retry button
- If preferences check fails → Default to onboarding flow
- Use try-catch around all async operations
- Log errors with `debugPrint`

## Animation Details

### Recommended: flutter_animate
```dart
Image.asset('assets/logo.png')
  .animate()
  .fadeIn(duration: 400.ms)
  .scale(begin: Offset(0.8, 0.8), end: Offset(1.0, 1.0));
```

### Alternative: AnimatedOpacity + AnimatedScale
```dart
AnimatedOpacity(
  opacity: _opacity,
  duration: Duration(milliseconds: 400),
  child: Transform.scale(
    scale: _scale,
    child: Image.asset('assets/logo.png'),
  ),
)
```

## Assets Required
- `assets/logo/app_logo.png` (or use placeholder Icon)
- Background gradient uses theme colors

## Testing Checklist
- [ ] Splash appears immediately on app launch
- [ ] Animation plays smoothly
- [ ] First-time users navigate to welcome screen
- [ ] Returning users navigate to home screen
- [ ] Minimum 2s duration is respected
- [ ] Works in both light and dark mode
- [ ] No crashes if Hive not initialized

## Common Pitfalls
- ❌ Don't call `context.go()` in build method
- ❌ Don't use `setState` after navigation (widget unmounted)
- ❌ Don't forget `!mounted` check before navigation
- ✅ Always use `if (!mounted) return;` before navigation

## Code Example Structure
```dart
Future<void> _initialize() async {
  try {
    // Initialize Hive
    await Hive.initFlutter();
    await Hive.openBox('preferences');
    await Hive.openBox('bookmarks');

    // Check onboarding status
    final prefsProvider = context.read<UserPreferencesProvider>();
    await prefsProvider.loadPreferences();
    
    // Ensure minimum duration
    await Future.delayed(const Duration(milliseconds: 2500));

    // Navigate
    if (!mounted) return;
    
    if (prefsProvider.isOnboardingComplete) {
      context.go('/home');
    } else {
      context.go('/welcome');
    }
  } catch (e) {
    debugPrint('Splash initialization error: $e');
    // Navigate to onboarding as fallback
    if (!mounted) return;
    context.go('/welcome');
  }
}
```

## Dependencies on Other Features
- Depends on: UserPreferencesProvider
- Next screen: Welcome (onboarding) OR Home
- No widgets to extract (single screen feature)

---

**Priority**: P0 (Must Have)
**Complexity**: Low
**Estimated Time**: 30 minutes
