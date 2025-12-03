import 'package:flutter/material.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  // Singleton para facilitar o acesso em qualquer lugar do app
  static final ThemeController instance = ThemeController._();
  
  ThemeController._() : super(ThemeMode.system); // Começa seguindo o sistema

  void changeTheme(ThemeMode mode) {
    value = mode;
  }

  void toggleTheme() {
    if (value == ThemeMode.dark) {
      value = ThemeMode.light;
    } else {
      value = ThemeMode.dark;
    }
  }
  
  // Verifica se o tema atual é escuro
  bool get isDark => value == ThemeMode.dark;
}