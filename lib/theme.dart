import 'package:flutter/material.dart';

//
// LIGHT THEME
//
final ColorScheme excelerateLightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: const Color(0xFF00796B), // Deep Emerald
  onPrimary: Colors.white,
  secondary: const Color(0xFF2196F3), // Azure Blue
  onSecondary: Colors.white,
  tertiary: const Color(0xFF00E676), // Electric Green
  onTertiary: Colors.black,
  error: const Color(0xFFFF5252), // Coral Red
  onError: Colors.white,
  surface: Colors.white,
  onSurface: const Color(0xFF2E2E2E),
);

final ThemeData excelerateLightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: excelerateLightScheme,
  fontFamily: 'Poppins',

  // Texts
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xFF2E2E2E),
    ),
    bodyMedium: TextStyle(color: Color(0xFF7E8B92)), // Cool Gray
  ),

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF00796B),
    foregroundColor: Colors.white,
    elevation: 0,
  ),

  // Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00796B),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Color(0xFF2196F3)),
      foregroundColor: const Color(0xFF2196F3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF00E676),
    foregroundColor: Colors.black,
  ),

  // Cards
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    shadowColor: Colors.black12,
  ),

  // Chips
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFFE0F2F1),
    labelStyle: const TextStyle(color: Color(0xFF00796B)),
    selectedColor: const Color(0xFF00E676),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),

  // Progress indicators
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFF00E676),
    circularTrackColor: Color(0xFFB2DFDB),
  ),

  // Inputs
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
    ),
    labelStyle: TextStyle(color: Color(0xFF7E8B92)),
  ),

  // Divider
  dividerTheme: const DividerThemeData(color: Color(0xFFE0E0E0), thickness: 1),

  // Dialogs
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xFF2E2E2E),
    ),
    contentTextStyle: const TextStyle(color: Color(0xFF7E8B92)),
  ),
);

//
// DARK THEME
//
final ColorScheme excelerateDarkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: const Color(0xFF00E676),
  onPrimary: Colors.black,
  secondary: const Color(0xFF2196F3),
  onSecondary: Colors.white,
  tertiary: const Color(0xFF00796B),
  onTertiary: Colors.white,
  error: const Color(0xFFFF5252),
  onError: Colors.white,
  surface: const Color(0xFF2E2E2E),
  onSurface: Colors.white,
);

final ThemeData excelerateDarkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: excelerateDarkScheme,
  fontFamily: 'Poppins',

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1C1C1E),
    foregroundColor: Colors.white,
  ),

  cardTheme: CardThemeData(
    color: const Color(0xFF2E2E2E),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    shadowColor: Colors.black45,
  ),

  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFF263238),
    labelStyle: const TextStyle(color: Colors.white),
    selectedColor: const Color(0xFF00E676),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFF00E676),
    circularTrackColor: Color(0xFF37474F),
  ),

  dialogTheme: DialogThemeData(
    backgroundColor: const Color(0xFF2E2E2E),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    contentTextStyle: const TextStyle(color: Color(0xFFB0BEC5)),
  ),
);
