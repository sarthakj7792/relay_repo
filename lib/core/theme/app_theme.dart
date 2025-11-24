import 'package:flutter/material.dart';

class AppTheme {
  // Core Colors
  static const primaryColor = Color(0xFF6C5DD3); // Vibrant Purple
  static const accentColor = Color(0xFF3F8CFF); // Bright Blue
  static const backgroundDark = Color(0xFF1F1D2B); // Deep Dark Background
  static const cardDark = Color(0xFF252836); // Slightly lighter for cards
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFF808191);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF6C5DD3), Color(0xFF3F8CFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glassmorphism Colors
  static final glassColor = Colors.white.withOpacity(0.1);
  static final glassBorder = Colors.white.withOpacity(0.2);

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: cardDark,
      background: backgroundDark,
      onPrimary: Colors.white,
      onSurface: textPrimary,
    ),
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
    ),
    cardTheme: CardTheme(
      color: cardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: textSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
  );
}
