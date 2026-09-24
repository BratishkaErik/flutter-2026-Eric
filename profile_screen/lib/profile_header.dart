import "package:flutter/material.dart";

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        ClipOval(
          child: Image.asset(
            "assets/images/person.jpg",
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: textTheme.headlineSmall?.copyWith(
            fontFamily: "IBMPlexSans",
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          university,
          style: textTheme.bodyMedium?.copyWith(fontFamily: "IBMPlexSans"),
        ),
      ],
    );
  }
}
