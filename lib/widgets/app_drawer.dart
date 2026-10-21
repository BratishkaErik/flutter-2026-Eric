import 'package:flutter/material.dart';

import '../models/app_item.dart';
import '../models/profile.dart';

class AppDrawer extends StatelessWidget {
  final Profile profile;
  final List<AppItem> apps;
  final VoidCallback onResetData;

  const AppDrawer({
    super.key,
    required this.profile,
    required this.apps,
    required this.onResetData,
  });

  Future<void> _showAboutDialog(BuildContext context) async {
    Navigator.pop(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('About ByteStore'),
          content: const Text(
            'ByteStore — Fake App Store & Beta Hub\n'
            'Built for Flutter Lab 1 (Weeks 1–7).\n\n'
            'All data lives in memory without network or local storage.\n'
            'Features 12 seed applications, category filtering, search, '
            'responsive phone and tablet layout.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleResetData(BuildContext context) async {
    Navigator.pop(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset store data?'),
          content: const Text(
            'This action will restore the original twelve seed apps and clear your tester profile. This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return;
    if (confirmed == true) {
      onResetData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seed apps restored and profile cleared.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasProfile = profile.name.trim().isNotEmpty;
    final String groupText;
    if (!hasProfile) {
      groupText = 'Not registered as tester';
    } else if (profile.group.isNotEmpty) {
      groupText = 'Group: ${profile.group}';
    } else {
      groupText = 'No group code assigned';
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  child: Text(
                    hasProfile ? profile.name[0].toUpperCase() : '?',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  hasProfile ? profile.name : 'Guest Developer',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  groupText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: theme.colorScheme.primary),
            title: const Text('About'),
            onTap: () => _showAboutDialog(context),
          ),
          ListTile(
            leading: Icon(Icons.restart_alt, color: theme.colorScheme.error),
            title: Text(
              'Reset data',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _handleResetData(context),
          ),
        ],
      ),
    );
  }
}
