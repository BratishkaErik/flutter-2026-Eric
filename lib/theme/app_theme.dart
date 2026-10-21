import 'package:flutter/material.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF1E5BB0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
        dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
      ),
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
        dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
      ),
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}
