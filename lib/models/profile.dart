import 'package:flutter/foundation.dart';

@immutable
class Profile {
  final String name;
  final String group;

  const Profile({this.name = '', this.group = ''});

  const Profile.empty() : this(name: '', group: '');

  Profile copyWith({String? name, String? group}) {
    return Profile(name: name ?? this.name, group: group ?? this.group);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile && other.name == name && other.group == group;

  @override
  int get hashCode => Object.hash(name, group);
}
