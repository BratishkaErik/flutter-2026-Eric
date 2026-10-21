import 'package:flutter/material.dart';

import '../models/app_item.dart';
import '../models/category.dart';
import '../utils/format.dart';

class FormScreen extends StatefulWidget {
  final AppItem? initialApp;

  const FormScreen({super.key, this.initialApp});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _limitController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _descriptionController;

  late final FocusNode _titleFocusNode;
  late final FocusNode _locationFocusNode;
  late final FocusNode _limitFocusNode;
  late final FocusNode _dateFocusNode;
  late final FocusNode _timeFocusNode;
  late final FocusNode _descriptionFocusNode;

  late AppCategory _selectedCategory;
  late bool _mode;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  late final DateTime _initialDate;
  late final TimeOfDay _initialTime;
  late final String _initialTitle;
  late final String _initialLocation;
  late final String _initialLimit;
  late final String _initialDescription;
  late final AppCategory _initialCategory;
  late final bool _initialMode;

  bool _isSaving = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();

    final app = widget.initialApp;
    final now = DateTime.now();

    _initialTitle = app?.title ?? '';
    _initialCategory = app?.category ?? AppCategory.productivity;
    _initialMode = app?.mode ?? false;
    _initialLocation = app?.location ?? '';
    _initialLimit = (app?.limit ?? 25).toString();
    _initialDescription = app?.description ?? '';

    final initialWhen = app?.when ?? now.add(const Duration(days: 1));
    _initialDate = DateTime(
      initialWhen.year,
      initialWhen.month,
      initialWhen.day,
    );
    _initialTime = TimeOfDay(
      hour: initialWhen.hour,
      minute: initialWhen.minute,
    );

    _selectedCategory = _initialCategory;
    _mode = _initialMode;
    _selectedDate = _initialDate;
    _selectedTime = _initialTime;

    _titleController = TextEditingController(text: _initialTitle);
    _locationController = TextEditingController(text: _initialLocation);
    _limitController = TextEditingController(text: _initialLimit);
    _dateController = TextEditingController(text: formatAppDate(_selectedDate));
    _timeController = TextEditingController(
      text: formatAppTime(
        DateTime(2000, 1, 1, _selectedTime.hour, _selectedTime.minute),
      ),
    );
    _descriptionController = TextEditingController(text: _initialDescription);

    _titleFocusNode = FocusNode();
    _locationFocusNode = FocusNode();
    _limitFocusNode = FocusNode();
    _dateFocusNode = FocusNode();
    _timeFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();

    _titleController.addListener(_onFieldChanged);
    _locationController.addListener(_onFieldChanged);
    _limitController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.removeListener(_onFieldChanged);
    _locationController.removeListener(_onFieldChanged);
    _limitController.removeListener(_onFieldChanged);
    _descriptionController.removeListener(_onFieldChanged);

    _titleController.dispose();
    _locationController.dispose();
    _limitController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();

    _titleFocusNode.dispose();
    _locationFocusNode.dispose();
    _limitFocusNode.dispose();
    _dateFocusNode.dispose();
    _timeFocusNode.dispose();
    _descriptionFocusNode.dispose();

    super.dispose();
  }

  bool get _dirty {
    final titleChanged = _titleController.text != _initialTitle;
    final locationChanged = _locationController.text != _initialLocation;
    final limitChanged = _limitController.text != _initialLimit;
    final descriptionChanged =
        _descriptionController.text != _initialDescription;
    final categoryChanged = _selectedCategory != _initialCategory;
    final modeChanged = _mode != _initialMode;
    final dateChanged = _selectedDate != _initialDate;
    final timeChanged = _selectedTime != _initialTime;

    return titleChanged ||
        locationChanged ||
        limitChanged ||
        descriptionChanged ||
        categoryChanged ||
        modeChanged ||
        dateChanged ||
        timeChanged;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDate = widget.initialApp == null ? now : DateTime(now.year - 2);
    final lastDate = DateTime(now.year + 5);

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = formatAppDate(picked);
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = formatAppTime(
          DateTime(2000, 1, 1, picked.hour, picked.minute),
        );
      });
    }
  }

  Future<bool?> _showDiscardDialog() {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Discard changes?'),
          content: const Text(
            'You have unsaved changes that will be lost if you leave.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Keep editing'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;

    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final combinedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final descText = _descriptionController.text.trim();
    final limitValue = int.parse(_limitController.text.trim());

    final initial = widget.initialApp;
    final AppItem resultApp;

    if (initial != null) {
      resultApp = initial.copyWith(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        when: combinedDateTime,
        limit: limitValue,
        mode: _mode,
        location: _locationController.text.trim(),
        description: descText.isNotEmpty ? descText : null,
        clearDescription: descText.isEmpty,
      );
    } else {
      resultApp = AppItem(
        id: 'app-${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        category: _selectedCategory,
        when: combinedDateTime,
        limit: limitValue,
        testers: const [],
        mode: _mode,
        location: _locationController.text.trim(),
        description: descText.isNotEmpty ? descText : null,
        isFavourite: false,
      );
    }

    _saved = true;
    Navigator.of(context).pop(resultApp);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.initialApp != null;

    return PopScope(
      canPop: _saved || !_dirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final discard = await _showDiscardDialog();
        if (discard == true && context.mounted) {
          _saved = true;
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(isEditing ? 'Edit App' : 'Publish App')),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    focusNode: _titleFocusNode,
                    maxLength: 60,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'App Name',
                      hintText: 'e.g. ByteCraft Studio',
                      prefixIcon: Icon(Icons.title),
                    ),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.length < 3) {
                        return 'App name must be at least 3 characters long';
                      }
                      if (text.length > 60) {
                        return 'App name cannot exceed 60 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<AppCategory>(
                    initialValue: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(
                        _selectedCategory.icon,
                        color: _selectedCategory.color(theme.colorScheme),
                      ),
                    ),
                    items: AppCategory.values.map((cat) {
                      return DropdownMenuItem<AppCategory>(
                        value: cat,
                        child: Row(
                          children: [
                            Icon(
                              cat.icon,
                              size: 18,
                              color: cat.color(theme.colorScheme),
                            ),
                            const SizedBox(width: 8),
                            Text(cat.label),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (cat) {
                      if (cat != null) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Web / Cloud App'),
                    subtitle: Text(
                      _mode
                          ? 'Browser application requiring URL link'
                          : 'Native binary requiring Package Identifier',
                    ),
                    secondary: Icon(
                      _mode ? Icons.cloud_outlined : Icons.android_outlined,
                    ),
                    value: _mode,
                    onChanged: (val) {
                      setState(() {
                        _mode = val;
                      });
                      _locationFocusNode.requestFocus();
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _locationController,
                    focusNode: _locationFocusNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: _mode
                        ? TextInputType.url
                        : TextInputType.text,
                    decoration: InputDecoration(
                      labelText: _mode ? 'Web App URL' : 'Package Identifier',
                      hintText: _mode
                          ? 'https://bytestore.io/app/demo'
                          : 'com.bytestore.demoapp',
                      prefixIcon: Icon(_mode ? Icons.link : Icons.fingerprint),
                    ),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return _mode
                            ? 'Web App URL is required'
                            : 'Package Identifier is required';
                      }
                      if (_mode && !text.contains('://')) {
                        return 'Web App URL must contain "://" (e.g. https://...)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _limitController,
                    focusNode: _limitFocusNode,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Beta Tester Limit',
                      hintText: '1 to 500',
                      prefixIcon: Icon(Icons.group_outlined),
                    ),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      final parsed = int.tryParse(text);
                      if (parsed == null || parsed < 1 || parsed > 500) {
                        return 'Limit must be an integer between 1 and 500';
                      }
                      final initial = widget.initialApp;
                      if (initial != null && parsed < initial.count) {
                        return 'Limit cannot be less than current testers (${initial.count})';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dateController,
                          focusNode: _dateFocusNode,
                          readOnly: true,
                          onTap: _pickDate,
                          decoration: const InputDecoration(
                            labelText: 'Launch Date',
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                          validator: (_) {
                            if (!isEditing) {
                              final combined = DateTime(
                                _selectedDate.year,
                                _selectedDate.month,
                                _selectedDate.day,
                                _selectedTime.hour,
                                _selectedTime.minute,
                              );
                              if (combined.isBefore(DateTime.now())) {
                                return 'Must be in the future';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _timeController,
                          focusNode: _timeFocusNode,
                          readOnly: true,
                          onTap: _pickTime,
                          decoration: const InputDecoration(
                            labelText: 'Launch Time',
                            prefixIcon: Icon(Icons.access_time),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    focusNode: _descriptionFocusNode,
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Release Notes / Description (optional)',
                      hintText: 'What is new in this version...',
                      prefixIcon: Icon(Icons.notes_outlined),
                    ),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _isSaving ? null : _handleSave,
                    child: _isSaving
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : Text(isEditing ? 'Save Changes' : 'Publish to Store'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
