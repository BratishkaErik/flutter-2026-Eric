import "package:flutter/material.dart";
import "package:profile_screen/data.dart";
import "package:profile_screen/info_row.dart";
import "package:profile_screen/profile_header.dart";

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const ProfileHeader(name: myName, university: myUniversity),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          for (final fact in facts)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: InfoRow(label: fact.label, value: fact.value),
            ),
        ],
      ),
    );
  }
}
