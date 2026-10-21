import 'package:flutter/material.dart';

import '../models/app_item.dart';
import '../utils/format.dart';
import 'badge_container.dart';

class AppCard extends StatelessWidget {
  final AppItem app;
  final VoidCallback onTap;
  final VoidCallback onToggleFavourite;

  const AppCard({
    super.key,
    required this.app,
    required this.onTap,
    required this.onToggleFavourite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (:taken, :free) = app.places;

    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: app.category.color(theme.colorScheme),
                    foregroundColor: app.category.onColor(theme.colorScheme),
                    child: Icon(app.category.icon, size: 20),
                  ),
                  if (app.isFull)
                    const Positioned(
                      top: -4,
                      right: -6,
                      child: BadgeContainer(text: 'FULL', isAlert: true),
                    )
                  else if (free <= 5)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: BadgeContainer(text: '$free left', isAlert: false),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      app.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatAppDateTime(app.when),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          app.mode ? Icons.link : Icons.android_outlined,
                          size: 14,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            app.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  app.isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: app.isFavourite
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                ),
                tooltip: app.isFavourite
                    ? 'Remove from favourites'
                    : 'Add to favourites',
                onPressed: onToggleFavourite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
