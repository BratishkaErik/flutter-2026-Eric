import 'package:flutter/material.dart';

import '../../models/app_item.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state_view.dart';

class FavouritesTab extends StatelessWidget {
  final List<AppItem> apps;
  final ValueChanged<AppItem> onOpenDetail;
  final ValueChanged<AppItem> onToggleFavourite;
  final VoidCallback onExploreApps;

  const FavouritesTab({
    super.key,
    required this.apps,
    required this.onOpenDetail,
    required this.onToggleFavourite,
    required this.onExploreApps,
  });

  @override
  Widget build(BuildContext context) {
    final favouriteApps = apps.where((app) => app.isFavourite).toList();

    if (favouriteApps.isEmpty) {
      return EmptyStateView(
        icon: Icons.favorite_border,
        message: 'No favourite apps yet.\nBookmark apps from the store to find them here.',
        buttonLabel: 'Explore Apps',
        onButtonPressed: onExploreApps,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return GridView.builder(
            padding: const EdgeInsets.all(12.0),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 360,
              mainAxisExtent: 130,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: favouriteApps.length,
            itemBuilder: (context, index) {
              final app = favouriteApps[index];
              return AppCard(
                app: app,
                onTap: () => onOpenDetail(app),
                onToggleFavourite: () => onToggleFavourite(app),
              );
            },
          );
        } else {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            itemCount: favouriteApps.length,
            separatorBuilder: (_, _) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final app = favouriteApps[index];
              return AppCard(
                app: app,
                onTap: () => onOpenDetail(app),
                onToggleFavourite: () => onToggleFavourite(app),
              );
            },
          );
        }
      },
    );
  }
}
