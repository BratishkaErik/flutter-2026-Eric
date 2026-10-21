import 'package:flutter/material.dart';

import '../models/countdown.dart';

class CountdownBadge extends StatelessWidget {
  final Countdown countdown;

  const CountdownBadge({super.key, required this.countdown});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (label, icon, bgColor, fgColor) = switch (countdown) {
      Upcoming(:final remaining) => (
        _formatUpcoming(remaining),
        Icons.schedule,
        theme.colorScheme.secondaryContainer,
        theme.colorScheme.onSecondaryContainer,
      ),
      Started(:final elapsed) => (
        _formatStarted(elapsed),
        Icons.play_arrow_outlined,
        theme.colorScheme.primaryContainer,
        theme.colorScheme.onPrimaryContainer,
      ),
      Ended() => (
        'Released',
        Icons.done_all,
        theme.colorScheme.surfaceContainerHighest,
        theme.colorScheme.onSurfaceVariant,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fgColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatUpcoming(Duration d) {
    if (d.inDays > 0) {
      final hours = d.inHours % 24;
      return hours > 0 ? '${d.inDays}d ${hours}h left' : '${d.inDays}d left';
    }
    if (d.inHours > 0) {
      final minutes = d.inMinutes % 60;
      return minutes > 0
          ? '${d.inHours}h ${minutes}m left'
          : '${d.inHours}h left';
    }
    return '${d.inMinutes}m left';
  }

  String _formatStarted(Duration d) {
    if (d.inMinutes < 60) {
      return 'Started ${d.inMinutes}m ago';
    }
    return 'Started ${d.inHours}h ago';
  }
}
