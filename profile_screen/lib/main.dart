import "package:flutter/material.dart";
import "package:profile_screen/data.dart";
import "package:profile_screen/info_row.dart";
import "package:profile_screen/profile_header.dart";

void main() {
  runApp(const ProfileApp());
}

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Profile",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text("My profile"), centerTitle: true),
        body: Padding(
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
        ),
      ),
    );
  }
}
