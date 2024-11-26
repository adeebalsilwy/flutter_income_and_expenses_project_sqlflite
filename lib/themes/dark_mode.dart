import 'package:flutter/material.dart';

ThemeData mydarkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF1A1A1A), // Background color
  appBarTheme: AppBarTheme(
    color: const Color(0xFF2C2C2C), // AppBar color
    titleTextStyle: const TextStyle(
      color: Color(0xFFB3E5FC), // Title text color
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFFB3E5FC), // Icon color in AppBar
    ),
    elevation: 3, // Shadow below AppBar
  ),
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFF2C2C2C), // Primary color
    onPrimary: const Color(0xFFB3E5FC), // Text color on primary
    secondary: const Color(0xFF455A64), // Secondary color
    onSecondary: Colors.white, // Text color on secondary
    background: const Color(0xFF1A1A1A), // Background color
    surface: const Color(0xFF2D2D2D), // Surface color
    onSurface: Colors.white70, // Text color on surface
    error: const Color(0xFFE57373), // Error color
    onError: Colors.white, // Text color on error
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white, // Large text color
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.white70, // Regular text color
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Colors.white60, // Secondary text color
    ),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF2D2D2D), // Card background color
    elevation: 6,
    margin: const EdgeInsets.all(10), // Spacing between cards
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16), // Rounded corners
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black, backgroundColor: const Color(0xFF81D4FA), // Text and icon color
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
    ),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: const TextStyle(
      color: Colors.white, // Text color in DropdownButton
      fontSize: 16,
    ),
    menuStyle: MenuStyle(
      backgroundColor: MaterialStateProperty.all(
          const Color(0xFF2C2C2C)), // Dropdown menu background
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF81D4FA), // FAB color
    foregroundColor: Colors.black, // Icon color inside FAB
    elevation: 8,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2D2D2D), // Field fill color
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade600),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF81D4FA)),
      borderRadius: BorderRadius.circular(10),
    ),
    hintStyle: const TextStyle(
      color: Colors.white60, // Hint text color
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFFB3E5FC), // General icon color
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor:
          MaterialStateProperty.all(const Color(0xFFB3E5FC)), // Text color
      overlayColor: MaterialStateProperty.all(
          const Color(0xFF455A64)), // Ripple effect color
      textStyle: MaterialStateProperty.all(
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
      ),
    ),
  ),
  
);
