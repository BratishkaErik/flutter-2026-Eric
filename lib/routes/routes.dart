import 'package:flutter/material.dart';

import '../models/app_item.dart';
import '../models/profile.dart';
import '../screens/detail_screen.dart';
import '../screens/form_screen.dart';

class Routes {
  static const String shell = '/';
  static const String detail = '/detail';
  static const String form = '/form';
}

class FormArguments {
  final AppItem? initialApp;

  const FormArguments({this.initialApp});
}

class DetailArguments {
  final AppItem app;
  final Profile profile;
  final ValueChanged<AppItem> onUpdateApp;
  final ValueChanged<String> onDeleteApp;
  final VoidCallback onSwitchToProfileTab;

  const DetailArguments({
    required this.app,
    required this.profile,
    required this.onUpdateApp,
    required this.onDeleteApp,
    required this.onSwitchToProfileTab,
  });
}

Route<dynamic>? onGenerateAppRoute(RouteSettings settings) {
  if (settings.name == Routes.detail) {
    final args = settings.arguments as DetailArguments;
    return MaterialPageRoute<void>(
      builder: (_) => DetailScreen(arguments: args),
      settings: settings,
    );
  }

  if (settings.name == Routes.form) {
    final args = settings.arguments as FormArguments?;
    return MaterialPageRoute<AppItem>(
      builder: (_) => FormScreen(initialApp: args?.initialApp),
      settings: settings,
    );
  }

  return null;
}

Route<dynamic> onUnknownAppRoute(RouteSettings settings) {
  return MaterialPageRoute<void>(
    builder: (context) => Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: const Center(child: Text('Not found')),
    ),
    settings: settings,
  );
}
