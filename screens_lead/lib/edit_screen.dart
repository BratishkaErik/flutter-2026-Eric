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

  bool get _dirty => _name != widget.student.name;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        final shouldDiscard = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Discard changes?'),
            actions: [
              TextButton(
                child: const Text('Keep editing'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('Discard'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );

        if (shouldDiscard == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}
