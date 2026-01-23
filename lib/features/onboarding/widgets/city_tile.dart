import 'package:flutter/material.dart';

/// City Tile Widget - Displays a selectable city in the list
class CityTile extends StatelessWidget {
  final String city;
  final bool isSelected;
  final VoidCallback? onTap;

  const CityTile({
    super.key,
    required this.city,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // Location icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.location_city,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // City name
                Expanded(
                  child: Text(
                    city,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                // Checkmark for selected
                if (isSelected)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 18,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
