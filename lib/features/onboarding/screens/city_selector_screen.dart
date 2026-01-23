import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_nest/core/constants/cities.dart';
import 'package:news_nest/features/onboarding/widgets/city_tile.dart';
import 'package:news_nest/providers/onboarding_provider.dart';
import 'package:news_nest/routes/app_router.dart';
import 'package:news_nest/shared/widgets/primary_button.dart';
import 'package:provider/provider.dart';

/// City Selector Screen - Let users choose their city for local news
class CitySelectorScreen extends StatefulWidget {
  const CitySelectorScreen({super.key});

  @override
  State<CitySelectorScreen> createState() => _CitySelectorScreenState();
}

class _CitySelectorScreenState extends State<CitySelectorScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _filteredCities {
    if (_searchQuery.isEmpty) {
      return IndianCities.popular;
    }
    return IndianCities.all
        .where(
          (city) => city.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Where are you located?',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get personalized local news from your city',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
                decoration: InputDecoration(
                  hintText: 'Search city...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
            // Section header
            if (_searchQuery.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Popular Cities',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            // City list
            Expanded(
              child: Consumer<OnboardingProvider>(
                builder: (context, provider, _) {
                  final cities = _filteredCities;

                  if (cities.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 64,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No cities found',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      final isSelected = provider.selectedCity == city;

                      return CityTile(
                        city: city,
                        isSelected: isSelected,
                        onTap: () => provider.setCity(city),
                      );
                    },
                  );
                },
              ),
            ),
            // Continue/Skip buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Consumer<OnboardingProvider>(
                builder: (context, provider, _) {
                  return Column(
                    children: [
                      PrimaryButton(
                        text: 'Continue',
                        onPressed: provider.canProceedFromCity
                            ? () => _completeOnboarding(context, provider)
                            : null,
                        icon: Icons.arrow_forward,
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => _completeOnboarding(context, provider),
                        child: Text(
                          'Skip for now',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeOnboarding(
    BuildContext context,
    OnboardingProvider provider,
  ) async {
    await provider.completeOnboarding();
    if (context.mounted) {
      context.go(AppRoutes.onboardingComplete);
    }
  }
}
