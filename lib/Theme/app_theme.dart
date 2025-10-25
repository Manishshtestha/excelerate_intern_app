import 'package:flutter/material.dart';

class AppTheme {
  // Primary brand colors matching the Excelerate logo
  static const Color primaryOrange = Color(0xFFFF5C00);
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color accentOrange = Color(0xFFFF7A2F);

  // Supporting colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
import 'package:flutter/material.dart';

class AppTheme {
  // ---------- Brand Colors ----------
  // Define the main brand colors to maintain consistent UI styling.
  static const Color primaryOrange = Color(0xFFFF5C00); // Main accent color (Excelerate orange)
  static const Color primaryBlack = Color(0xFF1A1A1A);  // Primary text and icon color
  static const Color accentOrange = Color(0xFFFF7A2F);  // Secondary orange shade for highlights

  // ---------- Supporting Colors ----------
  static const Color backgroundColor = Color(0xFFF5F5F5); // App background color (light grey)
  static const Color cardColor = Color(0xFFFFFFFF);        // Card and container background (white)
  static const Color textPrimary = Color(0xFF1A1A1A);      // Default text color (dark)
  static const Color textSecondary = Color(0xFF666666);    // Secondary text (muted grey)

  // ---------- Theme Configuration ----------
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryOrange,                // Sets the primary color for the theme
    scaffoldBackgroundColor: backgroundColor,   // Background for Scaffold widgets

    colorScheme: ColorScheme.light(
      primary: primaryOrange,                   // Used across buttons, sliders, etc.
      secondary: accentOrange,                  // Used for highlights and accents
      surface: cardColor,                       // Default surface color for cards and sheets
      background: backgroundColor,              // Default background color
    ),

    // ---------- AppBar Theme ----------
    appBarTheme: AppBarTheme(
      backgroundColor: cardColor,               // White AppBar background
      foregroundColor: primaryBlack,            // AppBar text and icon color
      elevation: 0,                             // Flat look (no shadow)
      centerTitle: true,                        // Centers the title text
      titleTextStyle: TextStyle(
        color: primaryBlack,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // ---------- Elevated Button Theme ----------
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,         // Button background color
        foregroundColor: Colors.white,          // Button text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded button edges
        ),
      ),
    ),

    // ---------- Input Field Theme ----------
    inputDecorationTheme: InputDecorationTheme(
      filled: true,                             // Enables filled background for text fields
      fillColor: Colors.grey[50],               // Light background color for inputs
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!), // Default border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryOrange, width: 2), // Highlight when focused
      ),
    ),

    // ---------- Bottom Navigation Bar Theme ----------
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryOrange,         // Highlighted icon/text color
      unselectedItemColor: Colors.grey,         // Default color for unselected items
      type: BottomNavigationBarType.fixed,      // Keeps all items visible
    ),
  );
}

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryOrange,
    scaffoldBackgroundColor: backgroundColor,

    colorScheme: ColorScheme.light(
      primary: primaryOrange,
      secondary: accentOrange,
      surface: cardColor,
      background: backgroundColor,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: cardColor,
      foregroundColor: primaryBlack,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: primaryBlack,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryOrange, width: 2),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryOrange,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
