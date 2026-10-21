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
      AppCategory.games => colorScheme.primaryFixed,
      AppCategory.productivity => colorScheme.secondaryFixed,
      AppCategory.social => colorScheme.tertiaryFixed,
      AppCategory.education => colorScheme.primaryFixedDim,
      AppCategory.utilities => colorScheme.secondaryFixedDim,
    };
  }

  Color onColor(ColorScheme colorScheme) {
    return switch (this) {
      AppCategory.games => colorScheme.onPrimaryFixed,
      AppCategory.productivity => colorScheme.onSecondaryFixed,
      AppCategory.social => colorScheme.onTertiaryFixed,
      AppCategory.education => colorScheme.onPrimaryFixedVariant,
      AppCategory.utilities => colorScheme.onSecondaryFixedVariant,
    };
  }
}
