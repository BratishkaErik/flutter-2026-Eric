import 'package:flutter/material.dart';
import 'package:screens_lead/students.dart';

import 'edit_screen.dart';

class DetailScreen extends StatefulWidget {
  final Student student;

  const DetailScreen({super.key, required this.student});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Student _student = widget.student;

  Future<void> _edit() async {
    final name = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => EditScreen(student: _student)),
    );
    if (name == null || !mounted) return; // backed out, or we are gone
    setState(() => _student = _student.copyWith(name: name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_student.name),
        actions: [IconButton(icon: const Icon(Icons.edit), onPressed: _edit)],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Group'),
            subtitle: Text(_student.group),
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Email'),
            subtitle: Text(_student.email),
          ),
        ],
      ),
    );
  }
}
