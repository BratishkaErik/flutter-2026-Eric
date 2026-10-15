import 'package:flutter/material.dart';
import 'package:screens_lead/students.dart';

class EditScreen extends StatefulWidget {
  final Student student;

  const EditScreen({super.key, required this.student});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late String _name = widget.student.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: widget.student.name,
              ),
              onChanged: (v) => setState(() => _name = v),
            ),
            const SizedBox(height: 16),
            FilledButton(
              child: const Text('Save'),
              onPressed: () => Navigator.of(context).pop(_name),
            ),
          ],
        ),
      ),
    );
  }
}
