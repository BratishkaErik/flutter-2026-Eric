import 'package:flutter/material.dart';

import 'models/book.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _author = TextEditingController();
  final _pages = TextEditingController();
  final _year = TextEditingController();

  @override
  void dispose() {
    for (final c in [_title, _author, _pages, _year]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        title: _title.text.trim(),
        author: _author.text.trim(),
        pages: int.parse(_pages.text.trim()),
        year: int.tryParse(_year.text.trim()),
      );
      Navigator.of(context).pop(book);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Book')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                validator: (v) => (v ?? '').trim().length < 2
                    ? 'Title must be at least 2 characters'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _author,
                decoration: const InputDecoration(labelText: 'Author'),
                textInputAction: TextInputAction.next,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Author is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pages,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Pages'),
                textInputAction: TextInputAction.next,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'A whole number above 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _year,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Year (optional)'),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                validator: (v) {
                  final val = (v ?? '').trim();
                  if (val.isEmpty) return null;
                  final y = int.tryParse(val);
                  final currentYear = DateTime.now().year;
                  if (y == null || y < 1450 || y > currentYear) {
                    return 'Enter a valid year (1450-$currentYear)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
