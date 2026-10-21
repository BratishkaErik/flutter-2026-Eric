import 'package:flutter/material.dart';

import 'routes/routes.dart';
import 'screens/shell_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _handleThemeModeChanged(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByteStore',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      routes: {
        Routes.shell: (context) => ShellScreen(
          themeMode: _themeMode,
          onThemeModeChanged: _handleThemeModeChanged,
        ),
      },
      onGenerateRoute: onGenerateAppRoute,
      onUnknownRoute: onUnknownAppRoute,
    );
  }
}
