import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_nest/core/constants/app_constants.dart';
import 'package:news_nest/core/constants/categories.dart';
import 'package:news_nest/features/onboarding/widgets/interest_tile.dart';
import 'package:news_nest/providers/onboarding_provider.dart';
import 'package:news_nest/routes/app_router.dart';
import 'package:news_nest/shared/widgets/primary_button.dart';
import 'package:provider/provider.dart';

/// Interest Picker Screen - Let users choose their news interests
class InterestPickerScreen extends StatelessWidget {
  const InterestPickerScreen({super.key});

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
                        flex: 2,
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
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.3,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'What interests you?',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Consumer<OnboardingProvider>(
                    builder: (context, provider, _) {
                      return Text(
                        'Select at least ${AppConstants.minInterests} topics (${provider.selectedInterests.length}/${AppConstants.maxInterests})',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Grid of interests
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Consumer<OnboardingProvider>(
                  builder: (context, provider, _) {
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.4,
                          ),
                      itemCount: AppCategories.all.length,
                      itemBuilder: (context, index) {
                        final category = AppCategories.all[index];
                        final isSelected = provider.isInterestSelected(
                          category.id,
                        );
                        final canSelect =
                            provider.selectedInterests.length <
                                AppConstants.maxInterests ||
                            isSelected;

                        return InterestTile(
                          category: category,
                          isSelected: isSelected,
                          onTap: canSelect
                              ? () => provider.toggleInterest(category.id)
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            // Continue button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Consumer<OnboardingProvider>(
                builder: (context, provider, _) {
                  return PrimaryButton(
                    text: 'Continue',
                    onPressed: provider.canProceedFromInterests
                        ? () => context.go(AppRoutes.city)
                        : null,
                    icon: Icons.arrow_forward,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
