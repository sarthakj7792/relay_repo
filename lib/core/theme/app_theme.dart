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
  static final glassColor = Colors.white.withValues(alpha: 0.1);
  static final glassBorder = Colors.white.withValues(alpha: 0.2);

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: cardDark,
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
      iconTheme: IconThemeData(color: textPrimary),
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

  // Liquid Glass Theme Properties
  static const liquidBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFFF4F7FE), // Base Blue-Grey
      Color(0xFFE6EEFE), // Lighter Blue
      Color(0xFFF3E5F5), // Pale Purple
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static final glassCardDecoration = BoxDecoration(
    color: Colors.white.withValues(alpha: 0.65), // Slightly more transparent
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.8), // Crisp border
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF7090B0).withValues(alpha: 0.2), // Deeper shadow
        blurRadius: 24,
        offset: const Offset(0, 8),
        spreadRadius: 2,
      ),
    ],
  );

  static const liquidBackgroundGradientDark = LinearGradient(
    colors: [
      Color(0xFF1F1D2B), // Deep Dark Background
      Color(0xFF252836), // Slightly lighter
      Color(0xFF1F1D2B), // Deep Dark Background
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static final glassCardDecorationDark = BoxDecoration(
    color: const Color(0xFF252836).withValues(alpha: 0.6),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.15), // Visible border
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.4), // Stronger shadow
        blurRadius: 24,
        offset: const Offset(0, 8),
        spreadRadius: 2,
      ),
    ],
  );

  static final glassFabDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        primaryColor.withValues(alpha: 0.9),
        accentColor.withValues(alpha: 0.9),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    shape: BoxShape.circle,
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.8), // Very crisp border
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.6), // Stronger glow
        blurRadius: 24, // Softer dispersion
        offset: const Offset(0, 10),
        spreadRadius: 4, // Wider glow
      ),
    ],
  );

  static final glassFabDecorationDark = BoxDecoration(
    gradient: primaryGradient,
    shape: BoxShape.circle,
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.3),
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.4),
        blurRadius: 20,
        offset: const Offset(0, 8),
        spreadRadius: 2,
      ),
    ],
  );

  static final glassChipDecoration = BoxDecoration(
    color: Colors.white.withValues(alpha: 0.6), // More opaque
    borderRadius: BorderRadius.circular(24), // More rounded
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.8),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF7090B0).withValues(alpha: 0.15),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static final glassChipDecorationDark = BoxDecoration(
    color: const Color(0xFF252836).withValues(alpha: 0.6),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.2),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF4F7FE), // Fallback color
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: Colors.white.withValues(alpha: 0.7), // Semi-transparent surface
      onPrimary: Colors.white,
      onSurface: const Color(0xFF2B3674),
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
        color: Color(0xFF2B3674),
      ),
      iconTheme: IconThemeData(color: Color(0xFF2B3674)),
    ),
    cardTheme: CardTheme(
      color: Colors.white.withValues(alpha: 0.7), // Glassy cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 8,
        shadowColor: primaryColor.withValues(alpha: 0.4),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.5), // Glassy inputs
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
      hintStyle: const TextStyle(
        color: Color(0xFFA3AED0),
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    ),
  );
}
