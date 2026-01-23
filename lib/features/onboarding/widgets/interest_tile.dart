import 'package:flutter/material.dart';
import 'package:news_nest/core/constants/categories.dart';

/// Interest Tile Widget - Displays a selectable category tile
class InterestTile extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback? onTap;

  const InterestTile({
    super.key,
    required this.category,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = category.color;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withValues(alpha: 0.8), color],
                )
              : null,
          color: isSelected ? null : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Category emoji
                  Text(category.emoji, style: const TextStyle(fontSize: 28)),
                  const Spacer(),
                  // Category name
                  Text(
                    category.displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Checkmark for selected
            if (isSelected)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(Icons.check, size: 16, color: color),
                ),
              ),
            // Disabled overlay
            if (onTap == null && !isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
