import "package:flutter/material.dart";
import "package:profile_screen/profile_body.dart";

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
        body: ProfileBody(),
      ),
    );
  }
}
