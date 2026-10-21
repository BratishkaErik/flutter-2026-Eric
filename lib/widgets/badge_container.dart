import 'package:flutter/material.dart';

class BadgeContainer extends StatelessWidget {
  final String text;
  final bool isAlert;

  const BadgeContainer({super.key, required this.text, this.isAlert = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = isAlert
        ? theme.colorScheme.error
        : theme.colorScheme.tertiaryContainer;
    final textColor = isAlert
        ? theme.colorScheme.onError
        : theme.colorScheme.onTertiaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
