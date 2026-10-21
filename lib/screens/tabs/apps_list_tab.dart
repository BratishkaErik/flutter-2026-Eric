import 'package:flutter/material.dart';

import '../../models/app_item.dart';
import '../../models/category.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state_view.dart';

class AppsListTab extends StatefulWidget {
  final List<AppItem> apps;
  final ValueChanged<AppItem> onOpenDetail;
  final ValueChanged<AppItem> onToggleFavourite;
  final VoidCallback onOpenForm;

  const AppsListTab({
    super.key,
    required this.apps,
    required this.onOpenDetail,
    required this.onToggleFavourite,
    required this.onOpenForm,
  });

  @override
  State<AppsListTab> createState() => _AppsListTabState();
}

class _AppsListTabState extends State<AppsListTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  AppCategory? _selectedCategory;
  bool _showPastOnly = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = null;
      _showPastOnly = false;
    });
  }

  List<AppItem> get _filteredApps {
    final query = _searchQuery.trim().toLowerCase();

    final filtered = widget.apps.where((app) {
      final matchesQuery =
          query.isEmpty ||
          app.title.toLowerCase().contains(query) ||
          app.location.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == null || app.category == _selectedCategory;
      final matchesPast = !_showPastOnly || app.isPast;
      return matchesQuery && matchesCategory && matchesPast;
    }).toList();

    filtered.sort((a, b) => a.when.compareTo(b.when));
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayedApps = _filteredApps;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search applications by name or package...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _selectedCategory == null,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCategory = null;
                    });
                  }
                },
              ),
              const SizedBox(width: 8),
              for (final cat in AppCategory.values) ...[
                ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(cat.icon, size: 16),
                      const SizedBox(width: 6),
                      Text(cat.label),
                    ],
                  ),
                  selected: _selectedCategory == cat,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? cat : null;
                    });
                  },
                ),
                const SizedBox(width: 8),
              ],
              FilterChip(
                label: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, size: 16),
                    SizedBox(width: 6),
                    Text('Released Only'),
                  ],
                ),
                selected: _showPastOnly,
                onSelected: (selected) {
                  setState(() {
                    _showPastOnly = selected;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: displayedApps.isEmpty
              ? EmptyStateView(
                  icon: Icons.search_off_outlined,
                  message:
                      'No applications match your search or filter criteria.',
                  buttonLabel: 'Clear filters',
                  onButtonPressed: _clearFilters,
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 600) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(12.0),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 360,
                              mainAxisExtent: 130,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemCount: displayedApps.length,
                        itemBuilder: (context, index) {
                          final app = displayedApps[index];
                          return AppCard(
                            app: app,
                            onTap: () => widget.onOpenDetail(app),
                            onToggleFavourite: () =>
                                widget.onToggleFavourite(app),
                          );
                        },
                      );
                    } else {
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        itemCount: displayedApps.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          final app = displayedApps[index];
                          return AppCard(
                            app: app,
                            onTap: () => widget.onOpenDetail(app),
                            onToggleFavourite: () =>
                                widget.onToggleFavourite(app),
                          );
                        },
                      );
                    }
                  },
                ),
        ),
      ],
    );
  }
}
