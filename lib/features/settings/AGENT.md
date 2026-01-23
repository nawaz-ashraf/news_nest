# ⚙️ Settings Feature - Agent Instructions

## Feature Overview
The Settings feature allows users to manage their app preferences including theme selection, interest management, city changes, and access to legal/privacy information.

## Files in This Feature

| File | Purpose |
|------|---------|
| `screens/settings_screen.dart` | Settings menu and options |
| `widgets/settings_tile.dart` | Reusable settings list item |

---

## Settings Screen

### Acceptance Criteria
- ✅ Display user profile section (selected interests + city)
- ✅ Theme toggle (Light/Dark mode)
- ✅ Edit interests button → Navigate to interest picker
- ✅ Change city button → Navigate to city selector
- ✅ About app section
- ✅ Privacy policy link
- ✅ Terms of service link
- ✅ App version display
- ✅ Clear cache option
- ✅ Sign out option (if auth implemented)

### Screen Layout
```
┌─────────────────────────────────────┐
│  ← Back    Settings                 │
├─────────────────────────────────────┤
│                                     │
│  Your Preferences                   │
│  ┌─────────────────────────────┐   │
│  │ Interests: Tech, Sports...  │   │
│  │ City: Bangalore             │   │
│  └─────────────────────────────┘   │
│                                     │
│  Appearance                         │
│  ► Theme                  [Dark ▼]  │ ← Dropdown/Switch
│                                     │
│  Personalization                    │
│  ► Edit Interests              →    │
│  ► Change City                 →    │
│                                     │
│  App                                │
│  ► About NewsNest              →    │
│  ► Privacy Policy              →    │
│  ► Terms of Service            →    │
│  ► Clear Cache                      │
│                                     │
│  Version 1.0.0                      │
└─────────────────────────────────────┘
```

---

## Implementation

### Route Configuration
```dart
// In app_router.dart
GoRoute(
  path: '/settings',
  name: 'settings',
  builder: (context, state) => const SettingsScreen(),
),
```

### Screen Structure
```dart
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileSection(context),
          const SizedBox(height: 24),
          _buildAppearanceSection(context),
          const SizedBox(height: 24),
          _buildPersonalizationSection(context),
          const SizedBox(height: 24),
          _buildAppSection(context),
          const SizedBox(height: 24),
          _buildVersionInfo(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Preferences',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Interests
                Row(
                  children: [
                    const Icon(Icons.interests, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Interests:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Selector<UserPreferencesProvider, List<String>>(
                  selector: (_, provider) => provider.selectedInterests,
                  builder: (context, interests, _) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: interests.map((interest) {
                        return Chip(
                          label: Text(interest),
                          labelStyle: const TextStyle(fontSize: 12),
                        );
                      }).toList(),
                    );
                  },
                ),
                const Divider(height: 24),
                
                // City
                Row(
                  children: [
                    const Icon(Icons.location_city, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'City:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Selector<UserPreferencesProvider, String?>(
                      selector: (_, provider) => provider.selectedCity,
                      builder: (context, city, _) {
                        return Text(
                          city ?? 'Not selected',
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appearance',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SettingsTile(
          icon: Icons.palette,
          title: 'Theme',
          trailing: Selector<ThemeProvider, ThemeMode>(
            selector: (_, provider) => provider.themeMode,
            builder: (context, themeMode, _) {
              return DropdownButton<ThemeMode>(
                value: themeMode,
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System'),
                  ),
                ],
                onChanged: (mode) {
                  if (mode != null) {
                    context.read<ThemeProvider>().setThemeMode(mode);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalizationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personalization',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SettingsTile(
          icon: Icons.interests,
          title: 'Edit Interests',
          onTap: () {
            // Navigate to interest picker
            context.push('/interests');
          },
        ),
        SettingsTile(
          icon: Icons.location_city,
          title: 'Change City',
          onTap: () {
            // Navigate to city selector
            context.push('/city');
          },
        ),
      ],
    );
  }

  Widget _buildAppSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'App',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SettingsTile(
          icon: Icons.info_outline,
          title: 'About NewsNest',
          onTap: () {
            _showAboutDialog(context);
          },
        ),
        SettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          onTap: () {
            _launchURL('https://newsnest.com/privacy');
          },
        ),
        SettingsTile(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          onTap: () {
            _launchURL('https://newsnest.com/terms');
          },
        ),
        SettingsTile(
          icon: Icons.delete_outline,
          title: 'Clear Cache',
          onTap: () {
            _showClearCacheDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    return Center(
      child: Text(
        'Version 1.0.0',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'NewsNest',
      applicationVersion: '1.0.0',
      applicationIcon: const FlutterLogo(size: 48),
      children: [
        const Text(
          'Your personalized news companion. Stay informed with news that matters to you.',
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _showClearCacheDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache?'),
        content: const Text(
          'This will clear all cached news articles. You\'ll need an internet connection to reload them.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      // Clear cache logic
      // await context.read<NewsRepository>().clearCache();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cache cleared')),
      );
    }
  }
}
```

---

## Settings Tile Widget

### Purpose
Reusable list item for settings options.

### UI Specifications
```
┌────────────────────────────────────┐
│ [Icon]  Title                  →   │
└────────────────────────────────────┘
```

### Implementation
```dart
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: trailing ?? 
          (onTap != null ? const Icon(Icons.chevron_right) : null),
        onTap: onTap,
      ),
    );
  }
}
```

---

## ThemeProvider Implementation

### Provider Structure
```dart
class ThemeProvider extends ChangeNotifier {
  final PreferencesRepository _repository;

  ThemeProvider({PreferencesRepository? repository})
      : _repository = repository ?? PreferencesRepository();

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> loadThemeMode() async {
    _themeMode = await _repository.getThemeMode();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _repository.saveThemeMode(mode);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    await setThemeMode(newMode);
  }
}
```

---

## Testing Checklist
- [ ] All settings display correctly
- [ ] Theme toggle changes app theme
- [ ] Edit interests navigates to interest picker
- [ ] Change city navigates to city selector
- [ ] About dialog shows app info
- [ ] Privacy/Terms links open in browser
- [ ] Clear cache shows confirmation dialog
- [ ] Version number displays correctly
- [ ] Settings persist after app restart

---

## Common Pitfalls
- ❌ Don't forget to save preferences after changes
- ❌ Don't hardcode URLs (use constants)
- ✅ Confirm destructive actions (clear cache)
- ✅ Handle navigation properly (use context.push)
- ✅ Show feedback after actions (SnackBar)
- ✅ Validate URLs before launching

---

## AdMob Integration

### Ad-Related Settings
| Setting | Purpose | Implementation |
|---------|---------|----------------|
| Remove Ads | Premium upgrade option | Links to IAP (future) |

### Remove Ads Setting
```dart
Widget _buildAppSection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('App', ...),
      const SizedBox(height: 12),
      
      // Remove Ads (Premium) - Future IAP
      SettingsTile(
        icon: Icons.workspace_premium,
        title: 'Remove Ads',
        subtitle: 'Go ad-free with Premium',
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'UPGRADE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        onTap: () {
          // TODO: Implement IAP
          _showPremiumDialog(context);
        },
      ),
      
      // ... other settings tiles ...
    ],
  );
}

void _showPremiumDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Go Premium'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Remove all ads and enjoy:'),
          SizedBox(height: 12),
          Text('✓ Ad-free reading experience'),
          Text('✓ Faster app performance'),
          Text('✓ Support app development'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Maybe Later'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // TODO: Trigger IAP purchase flow
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Coming soon!')),
            );
          },
          child: const Text('Upgrade Now'),
        ),
      ],
    ),
  );
}
```

### Premium Status Check
```dart
// In AdMobService or dedicated PremiumService
Future<bool> isPremiumUser() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(StorageKeys.isPremium) ?? false;
}

// Use in screens to hide ads for premium users
if (await AdMobService.instance.isPremiumUser()) {
  // Don't show any ads
  return const SizedBox.shrink();
}
```

### Testing Checklist (Ads)
- [ ] Remove Ads tile appears in Settings
- [ ] Premium dialog shows upgrade benefits
- [ ] Coming soon message shows on upgrade tap
- [ ] Premium badge displays correctly
- [ ] Premium status check integration ready

---

**Priority**: P0 (Must Have)
**Complexity**: Low-Medium
**Estimated Time**: 2-3 hours
**Dependencies**: 
- ThemeProvider
- UserPreferencesProvider
- PreferencesRepository
- URL Launcher package
- AdMobService (for premium check)
