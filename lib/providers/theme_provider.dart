import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Default theme mode is light
  ThemeMode _themeMode = ThemeMode.light;

  // Getter for the current theme mode
  ThemeMode get themeMode => _themeMode;

  // Method to toggle between light and dark themes
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Notify listeners about the change
  }
}
