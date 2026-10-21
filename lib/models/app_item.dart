import 'package:flutter/foundation.dart';

import 'category.dart';

@immutable
class AppItem {
  final String id;
  final String title;
  final AppCategory category;
  final DateTime when;
  final int limit;
  final List<String> testers;
  final bool mode;
  final String location;
  final String? description;
  final bool isFavourite;

  const AppItem({
    required this.id,
    required this.title,
    required this.category,
    required this.when,
    required this.limit,
    this.testers = const [],
    required this.mode,
    required this.location,
    this.description,
    this.isFavourite = false,
  });

  AppItem.empty()
    : this(
        id: '',
        title: '',
        category: AppCategory.productivity,
        when: DateTime.now().add(const Duration(days: 1)),
        limit: 25,
        testers: const [],
        mode: false,
        location: '',
        description: null,
        isFavourite: false,
      );

  List<String> get names => testers;

  int get count => testers.length;

  int get freePlaces => limit - count;

  bool get isFull => count >= limit;

  bool get isPast => when.isBefore(DateTime.now());

  bool contains(String name) {
    final trimmed = name.trim().toLowerCase();
    if (trimmed.isEmpty) return false;
    return testers.any((n) => n.trim().toLowerCase() == trimmed);
  }

  ({int taken, int free}) get places =>
      (taken: count, free: (limit - count).clamp(0, limit));

  AppItem copyWith({
    String? id,
    String? title,
    AppCategory? category,
    DateTime? when,
    int? limit,
    List<String>? testers,
    bool? mode,
    String? location,
    String? description,
    bool clearDescription = false,
    bool? isFavourite,
  }) {
    return AppItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      when: when ?? this.when,
      limit: limit ?? this.limit,
      testers: testers != null ? List.unmodifiable(testers) : this.testers,
      mode: mode ?? this.mode,
      location: location ?? this.location,
      description: clearDescription ? null : (description ?? this.description),
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppItem &&
          other.id == id &&
          other.title == title &&
          other.category == category &&
          other.when == when &&
          other.limit == limit &&
          listEquals(other.testers, testers) &&
          other.mode == mode &&
          other.location == location &&
          other.description == description &&
          other.isFavourite == isFavourite;

  @override
  int get hashCode => Object.hash(
    id,
    title,
    category,
    when,
    limit,
    Object.hashAll(testers),
    mode,
    location,
    description,
    isFavourite,
  );
}

typedef Item = AppItem;
