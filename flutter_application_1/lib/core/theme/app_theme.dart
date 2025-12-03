import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // ==========================================================
  // PALETA DE CORES (ALTO CONTRASTE)
  // ==========================================================
  
  // MUDANÇA 1: Um verde bem mais escuro e sóbrio para "saltar" na tela
  static const _primaryColor = Color(0xFF2E5C4E); // Verde Floresta Profundo
  
  static const _secondaryColor = Color(0xFF8ABFA3); 
  
  // LIGHT: Fundo Gelo
  static const _lightBackground = Color(0xFFF0F2F0); // Um pouco mais cinza para destacar o branco
  static const _lightSurface = Colors.white;         // Cards brancos puros
  static const _lightText = Color(0xFF1A1C1A);       // Preto suave

  // DARK
  static const _darkBackground = Color(0xFF121212); 
  static const _darkSurface = Color(0xFF1E1E1E);    
  static const _darkText = Color(0xFFE0E0E0);       

  // ==========================================================
  // TEMA LIGHT
  // ==========================================================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightBackground,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _lightSurface,
        onSurface: _lightText,
        brightness: Brightness.light,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBackground,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: _lightText),
        titleTextStyle: TextStyle(
          color: _lightText, 
          fontSize: 18, 
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardThemeData(
        color: _lightSurface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          // Borda um pouco mais escura para contraste do card
          side: BorderSide(color: Colors.grey.shade300, width: 1), 
        ),
      ),

      // --- BOTÕES DE ALTO CONTRASTE ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor, // Verde Escuro
          foregroundColor: Colors.white,  // Texto Branco
          
          // MUDANÇA 2: Adicionei sombra (Elevation)
          elevation: 4, 
          shadowColor: _primaryColor.withValues(alpha: 0.4), // Sombra colorida
          
          minimumSize: const Size(100, 42), // Levemente mais altos para presença
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 14, 
            fontWeight: FontWeight.w800, // Extra Negrito
          ),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primaryColor;
          return Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
           if (states.contains(WidgetState.selected)) {
            return _primaryColor.withValues(alpha: 0.3); 
          }
          return Colors.grey.shade300; // Track mais visível quando desligado
        }),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurface,
        isDense: true, 
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        labelStyle: TextStyle(color: Colors.grey.shade800, fontSize: 14, fontWeight: FontWeight.w500),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        // Borda de input inativo mais visível
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)), 
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _primaryColor, width: 2)),
      ),
    );
  }

  // ==========================================================
  // TEMA DARK
  // ==========================================================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBackground,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        surface: _darkSurface,
        onSurface: _darkText,
        brightness: Brightness.dark,
        primary: _primaryColor, // Garante que o verde continue verde no dark
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _darkText),
        titleTextStyle: TextStyle(color: _darkText, fontSize: 18, fontWeight: FontWeight.bold),
      ),

      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 4, // Sombra também no dark mode
          shadowColor: Colors.black.withValues(alpha: 0.5),
          minimumSize: const Size(100, 42),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
      ),
      
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primaryColor;
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
           if (states.contains(WidgetState.selected)) return _primaryColor.withValues(alpha: 0.3);
          return Colors.white10;
        }),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _primaryColor)),
      ),
    );
  }

  static void setSystemStyle() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }
}