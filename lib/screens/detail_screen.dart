import 'dart:async';

import 'package:flutter/material.dart';

import '../models/app_item.dart';
import '../models/countdown.dart';
import '../routes/routes.dart';
import '../utils/format.dart';
import '../widgets/countdown_badge.dart';
import '../widgets/empty_state_view.dart';

class DetailScreen extends StatefulWidget {
  final DetailArguments arguments;

  const DetailScreen({super.key, required this.arguments});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late AppItem _app;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _app = widget.arguments.app;

    _countdownTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  bool get _hasProfileName => widget.arguments.profile.name.trim().isNotEmpty;

  bool get _isUserRegistered {
    if (!_hasProfileName) return false;
    return _app.contains(widget.arguments.profile.name);
  }

  Future<void> _handlePrimaryAction() async {
    if (!_hasProfileName) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          content: const Text(
            'Please register your tester name in the Profile tab first.',
          ),
          action: SnackBarAction(
            label: 'Profile',
            onPressed: () {
              messenger.hideCurrentSnackBar();
              widget.arguments.onSwitchToProfileTab();
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      );
      return;
    }

    final isRegistered = _isUserRegistered;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            isRegistered ? 'Leave Beta Testing?' : 'Join Beta Program?',
          ),
          content: Text(
            isRegistered
                ? 'Do you want to cancel your beta tester seat for "${_app.title}"?'
                : 'Join beta testing as "${widget.arguments.profile.name}" for "${_app.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(isRegistered ? 'Leave Beta' : 'Join Beta'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (confirmed == true) {
      final userName = widget.arguments.profile.name.trim();
      final AppItem updated;

      if (isRegistered) {
        final updatedTesters = _app.testers
            .where(
              (name) => name.trim().toLowerCase() != userName.toLowerCase(),
            )
            .toList();
        updated = _app.copyWith(testers: updatedTesters);
      } else {
        updated = _app.copyWith(testers: [..._app.testers, userName]);
      }

      setState(() {
        _app = updated;
      });
      widget.arguments.onUpdateApp(updated);
    }
  }

  Future<void> _handleEdit() async {
    final updatedItem = await Navigator.of(context).pushNamed<AppItem>(
      Routes.form,
      arguments: FormArguments(initialApp: _app),
    );

    if (!mounted) return;
    if (updatedItem != null) {
      setState(() {
        _app = updatedItem;
      });
      widget.arguments.onUpdateApp(updatedItem);
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Unpublish app?'),
          content: Text(
            'Are you sure you want to delete "${_app.title}" from the store? This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (confirmed == true) {
      widget.arguments.onDeleteApp(_app.id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRegistered = _isUserRegistered;
    final isFull = _app.isFull;

    final (:taken, :free) = _app.places;

    final double progressValue = _app.limit > 0
        ? (taken / _app.limit).clamp(0.0, 1.0)
        : 0.0;

    final Color progressColor;
    if (_app.isFull) {
      progressColor = theme.colorScheme.error;
    } else if (free <= 5) {
      progressColor = theme.colorScheme.tertiary;
    } else {
      progressColor = theme.colorScheme.primary;
    }

    final VoidCallback? primaryAction;
    final String primaryButtonLabel;
    if (isRegistered) {
      primaryAction = _handlePrimaryAction;
      primaryButtonLabel = 'Leave Beta';
    } else if (isFull) {
      primaryAction = null;
      primaryButtonLabel = 'Beta Slots Full';
    } else {
      primaryAction = _handlePrimaryAction;
      primaryButtonLabel = 'Join Beta';
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_app.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _handleEdit();
                } else if (value == 'delete') {
                  _handleDelete();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined),
                      SizedBox(width: 8),
                      Text('Edit App Details'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Unpublish App',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/header.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.surface.withAlpha(25),
                        theme.colorScheme.surface.withAlpha(210),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _app.category.color(theme.colorScheme),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _app.category.icon,
                          size: 16,
                          color: _app.category.onColor(theme.colorScheme),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _app.category.label,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: _app.category.onColor(theme.colorScheme),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 16,
                  child: CountdownBadge(
                    countdown: Countdown.fromDateTime(_app.when),
                  ),
                ),
              ],
            ),
            TabBar(
              tabs: [
                const Tab(icon: Icon(Icons.info_outline), text: 'Overview'),
                Tab(
                  icon: const Icon(Icons.group_outlined),
                  text: 'Testers ($taken/${_app.limit})',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _app.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.calendar_today_outlined,
                            color: theme.colorScheme.primary,
                          ),
                          title: const Text('Target Launch Date'),
                          subtitle: Text(formatAppDateTime(_app.when)),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            _app.mode ? Icons.link : Icons.android_outlined,
                            color: theme.colorScheme.primary,
                          ),
                          title: Text(
                            _app.mode ? 'Web App URL' : 'Package Identifier',
                          ),
                          subtitle: Text(_app.location),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.pie_chart_outline,
                            color: progressColor,
                          ),
                          title: const Text('Beta Tester Capacity'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                '$taken taken · $free free of ${_app.limit} total seats',
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progressValue,
                                  minHeight: 6,
                                  backgroundColor:
                                      theme.colorScheme.surfaceContainerHighest,
                                  color: progressColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_app.description case final desc?) ...[
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(
                            'Release Notes & Overview',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            desc,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                  _app.testers.isEmpty
                      ? const EmptyStateView(
                          icon: Icons.people_outline,
                          message: 'No registered beta testers yet.\nBe the first to join!',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: _app.testers.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final name = _app.testers[index];
                            final isYou =
                                _hasProfileName &&
                                name.trim().toLowerCase() ==
                                    widget.arguments.profile.name
                                        .trim()
                                        .toLowerCase();
                            final userGroup = widget.arguments.profile.group
                                .trim();

                            final String subtitleText;
                            if (isYou) {
                              subtitleText = userGroup.isNotEmpty
                                  ? 'Group: $userGroup (tap to change)'
                                  : 'No group assigned (tap to set in Profile)';
                            } else {
                              subtitleText = 'Community tester';
                            }

                            final String badgeText;
                            if (userGroup.isNotEmpty) {
                              badgeText = 'You · $userGroup';
                            } else {
                              badgeText = 'You';
                            }

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isYou
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.surfaceContainerHighest,
                                foregroundColor: isYou
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurfaceVariant,
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                                ),
                              ),
                              title: Text(
                                name,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: isYou
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              subtitle: Text(
                                subtitleText,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              onTap: isYou
                                  ? () {
                                      widget.arguments.onSwitchToProfileTab();
                                      Navigator.of(context).pop();
                                    }
                                  : null,
                              trailing: isYou
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            theme.colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        badgeText,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    )
                                  : null,
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isRegistered
                ? OutlinedButton(
                    onPressed: primaryAction,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: Text(primaryButtonLabel),
                  )
                : FilledButton(
                    onPressed: primaryAction,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: Text(primaryButtonLabel),
                  ),
          ),
        ),
      ),
    );
  }
}
