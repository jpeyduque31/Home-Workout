import 'package:flutter/material.dart';

class AppTheme {
  static const green = Color(0xFF39FF14);
  static const surface = Color(0xFF0D1510);
  static const border = Color(0xFF1E3324);
  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(seedColor: green, brightness: Brightness.dark).copyWith(primary: green, onPrimary: Colors.black, surface: surface);
    return ThemeData(useMaterial3: true, colorScheme: scheme, scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.black, foregroundColor: Colors.white, elevation: 0),
      cardTheme: CardThemeData(color: surface, elevation: 0, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)), side: BorderSide(color: border))),
      navigationBarTheme: NavigationBarThemeData(backgroundColor: surface, indicatorColor: green.withAlpha(35), labelTextStyle: const WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w600))),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: green, linearTrackColor: border));
  }
}
