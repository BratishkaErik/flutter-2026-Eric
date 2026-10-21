import 'package:flutter/material.dart';

enum AppCategory {
  games('Games', Icons.sports_esports_outlined),
  productivity('Productivity', Icons.work_outline),
  social('Social', Icons.chat_bubble_outline),
  education('Education', Icons.school_outlined),
  utilities('Utilities', Icons.build_outlined);

  final String label;
  final IconData icon;

  const AppCategory(this.label, this.icon);

  Color color(ColorScheme colorScheme) {
    return switch (this) {
      AppCategory.games => colorScheme.primary,
      AppCategory.productivity => colorScheme.secondary,
      AppCategory.social => colorScheme.tertiary,
      AppCategory.education => colorScheme.secondaryContainer,
      AppCategory.utilities => colorScheme.tertiaryContainer,
    };
  }

  Color onColor(ColorScheme colorScheme) {
    return switch (this) {
      AppCategory.games => colorScheme.onPrimary,
      AppCategory.productivity => colorScheme.onSecondary,
      AppCategory.social => colorScheme.onTertiary,
      AppCategory.education => colorScheme.onSecondaryContainer,
      AppCategory.utilities => colorScheme.onTertiaryContainer,
    };
  }
}
