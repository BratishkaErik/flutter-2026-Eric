import 'package:flutter/material.dart';

import '../../models/app_item.dart';
import '../../models/profile.dart';

class ProfileTab extends StatefulWidget {
  final Profile profile;
  final List<AppItem> apps;
  final ValueChanged<Profile> onUpdateProfile;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const ProfileTab({
    super.key,
    required this.profile,
    required this.apps,
    required this.onUpdateProfile,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _groupController;

  late final FocusNode _nameFocusNode;
  late final FocusNode _groupFocusNode;

  static final RegExp _groupRegExp = RegExp(r'^[A-Za-z0-9\-]{2,10}$');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _groupController = TextEditingController(text: widget.profile.group);

    _nameFocusNode = FocusNode();
    _groupFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.name != widget.profile.name &&
        _nameController.text != widget.profile.name) {
      _nameController.text = widget.profile.name;
    }
    if (oldWidget.profile.group != widget.profile.group &&
        _groupController.text != widget.profile.group) {
      _groupController.text = widget.profile.group;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    _nameFocusNode.dispose();
    _groupFocusNode.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final updated = widget.profile.copyWith(
      name: _nameController.text.trim(),
      group: _groupController.text.trim().toUpperCase(),
    );

    widget.onUpdateProfile(updated);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved successfully.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userName = widget.profile.name.trim();

    final onListsCount = userName.isNotEmpty
        ? widget.apps.where((app) => app.contains(userName)).length
        : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 0,
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName.isNotEmpty ? userName : 'Anonymous Tester',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.profile.group.isNotEmpty
                              ? 'Group: ${widget.profile.group}'
                              : 'No group assigned',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'You are in $onListsCount beta programs',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tester Profile Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Full Name / Tester Handle',
                    hintText: 'e.g. Alikhan M.',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  onFieldSubmitted: (_) => _saveProfile(),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return 'Please enter your tester name';
                    }
                    if (text.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _groupController,
                  focusNode: _groupFocusNode,
                  textInputAction: TextInputAction.done,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'Tester Group Code (Optional)',
                    hintText: 'e.g. QA-2026, DEV-01',
                    helperText: 'Optional. 2–10 characters, letter-number format (e.g. QA-2026, CS-21).',
                    helperMaxLines: 2,
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  onFieldSubmitted: (_) => _saveProfile(),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return null;
                    }
                    if (!_groupRegExp.hasMatch(text)) {
                      return 'Must be 2–10 characters, letter-number format (e.g. QA-2026, CS-21)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FilledButton.tonalIcon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Theme Preference',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10.0,
            children: [
              ChoiceChip(
                avatar: const Icon(Icons.brightness_auto, size: 18),
                label: const Text('System'),
                selected: widget.themeMode == ThemeMode.system,
                onSelected: (selected) {
                  if (selected) {
                    widget.onThemeModeChanged(ThemeMode.system);
                  }
                },
              ),
              ChoiceChip(
                avatar: const Icon(Icons.light_mode, size: 18),
                label: const Text('Light'),
                selected: widget.themeMode == ThemeMode.light,
                onSelected: (selected) {
                  if (selected) {
                    widget.onThemeModeChanged(ThemeMode.light);
                  }
                },
              ),
              ChoiceChip(
                avatar: const Icon(Icons.dark_mode, size: 18),
                label: const Text('Dark'),
                selected: widget.themeMode == ThemeMode.dark,
                onSelected: (selected) {
                  if (selected) {
                    widget.onThemeModeChanged(ThemeMode.dark);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
