import 'package:flutter/material.dart';

// AppTheme class defines a consistent design system for the entire app
class AppTheme {
  // ---------- Brand Colors ----------
  // These are the core colors that represent the app's brand identity.

  static const Color primaryOrange = Color(0xFFFF5C00); // Main accent color (Excelerate orange)
  static const Color primaryBlack = Color(0xFF1A1A1A);  // Primary color for text, icons, and titles
  static const Color accentOrange = Color(0xFFFF7A2F);  // Slightly lighter orange for highlights and secondary UI elements

  // ---------- Supporting Colors ----------
  // Additional colors to support UI components and maintain contrast.

  static const Color backgroundColor = Color(0xFFF5F5F5); // App background (light grey for modern, clean look)
  static const Color cardColor = Color(0xFFFFFFFF);        // Card and container background (white)
  static const Color textPrimary = Color(0xFF1A1A1A);      // Primary text color (dark)
  static const Color textSecondary = Color(0xFF666666);    // Muted grey for less important text

  // ---------- Theme Configuration ----------
  // The light theme configuration used throughout the app
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryOrange,                // Global primary color for the app
    scaffoldBackgroundColor: backgroundColor,   // Background color for Scaffold screens

    // Defines the main color palette used throughout the app
    colorScheme: ColorScheme.light(
      primary: primaryOrange,                   // Used in buttons, icons, and progress indicators
      secondary: accentOrange,                  // Used for accents or secondary highlights
      surface: cardColor,                       // Used for cards, modals, and sheets
      background: backgroundColor,              // General background color
    ),

    // ---------- AppBar Theme ----------
    appBarTheme: AppBarTheme(
      backgroundColor: cardColor,               // White background for app bar
      foregroundColor: primaryBlack,            // Text and icon color in app bar
      elevation: 0,                             // Flat design (no shadow)
      centerTitle: true,                        // Centers the title on the app bar
      titleTextStyle: TextStyle(
        color: primaryBlack,
        fontSize: 20,
        fontWeight: FontWeight.w600,            // Semi-bold title text
      ),
    ),

    // ---------- Elevated Button Theme ----------
    // Defines the default style for all ElevatedButtons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,         // Button background color
        foregroundColor: Colors.white,          // Text color for button labels
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners for modern look
        ),
      ),
    ),

    // ---------- Input Field Theme ----------
    // Standardized style for all text input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,                             // Enables filled background in inputs
      fillColor: Colors.grey[50],               // Light grey background inside text fields
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!), // Default light grey border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryOrange, width: 2), // Orange border when focused
      ),
    ),

    // ---------- Bottom Navigation Bar Theme ----------
    // Style configuration for the BottomNavigationBar widget
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryOrange,         // Active icon/text color
      unselectedItemColor: Colors.grey,         // Inactive icon/text color
      type: BottomNavigationBarType.fixed,      // Keeps all tabs visible and evenly spaced
    ),
  );
}
