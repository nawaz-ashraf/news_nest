import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_nest/core/constants/app_constants.dart';
import 'package:news_nest/core/constants/cities.dart';
import 'package:news_nest/providers/theme_provider.dart';
import 'package:news_nest/providers/user_preferences_provider.dart';
import 'package:news_nest/routes/app_router.dart';
import 'package:provider/provider.dart';

/// Settings Screen - App settings and preferences
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // App Info Section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.newspaper,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your Daily News Companion',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Appearance Section
          _buildSection(
            context: context,
            title: 'Appearance',
            children: [_buildThemeSelector(context)],
          ),

          const Divider(),

          // Preferences Section
          _buildSection(
            context: context,
            title: 'Preferences',
            children: [
              _buildInterestsSelector(context),
              _buildCitySelector(context),
            ],
          ),

          const Divider(),

          // About Section
          _buildSection(
            context: context,
            title: 'About',
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Version'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Privacy Policy'),
                onTap: () {
                  // TODO: Open privacy policy
                },
              ),
              ListTile(
                leading: const Icon(Icons.gavel_outlined),
                title: const Text('Terms of Service'),
                onTap: () {
                  // TODO: Open terms
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        return ListTile(
          leading: Icon(
            provider.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : provider.themeMode == ThemeMode.light
                ? Icons.light_mode
                : Icons.brightness_auto,
          ),
          title: const Text('Theme'),
          subtitle: Text(
            provider.themeMode == ThemeMode.dark
                ? 'Dark'
                : provider.themeMode == ThemeMode.light
                ? 'Light'
                : 'System',
          ),
          onTap: () => _showThemeDialog(context, provider),
        );
      },
    );
  }

  Future<void> _showThemeDialog(
    BuildContext context,
    ThemeProvider provider,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: provider.themeMode,
              onChanged: (value) {
                provider.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: provider.themeMode,
              onChanged: (value) {
                provider.setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: provider.themeMode,
              onChanged: (value) {
                provider.setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestsSelector(BuildContext context) {
    return Consumer<UserPreferencesProvider>(
      builder: (context, provider, _) {
        final interestsText = provider.hasInterests
            ? provider.selectedInterests.take(3).join(', ') +
                  (provider.selectedInterests.length > 3
                      ? ' +${provider.selectedInterests.length - 3}'
                      : '')
            : 'Not set';

        return ListTile(
          leading: const Icon(Icons.interests),
          title: const Text('Interests'),
          subtitle: Text(interestsText),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(AppRoutes.interests),
        );
      },
    );
  }

  Widget _buildCitySelector(BuildContext context) {
    return Consumer<UserPreferencesProvider>(
      builder: (context, provider, _) {
        return ListTile(
          leading: const Icon(Icons.location_on_outlined),
          title: const Text('City'),
          subtitle: Text(provider.selectedCity ?? 'Not set'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showCityPicker(context, provider),
        );
      },
    );
  }

  Future<void> _showCityPicker(
    BuildContext context,
    UserPreferencesProvider provider,
  ) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select City'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: IndianCities.popular.length,
            itemBuilder: (context, index) {
              final city = IndianCities.popular[index];
              return ListTile(
                title: Text(city),
                selected: city == provider.selectedCity,
                onTap: () => Navigator.pop(context, city),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selected != null) {
      await provider.setCity(selected);
    }
  }
}
