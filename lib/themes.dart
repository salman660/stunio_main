import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const bgColor = Color(0xFF1C1C1C);
// Light theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.kanitTextTheme(
    ThemeData.light().textTheme,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFD7D7D7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: const BorderSide(color: Color(0x505050)),
      ),
    ),
  ), colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
  ).copyWith(
    secondary: Colors.blueAccent, // Add more custom colors if needed
    secondaryContainer: Color(0xFF1C1C1C),
    // other properties...
  ).copyWith(background: Colors.white),
);

// Dark theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: GoogleFonts.kanitTextTheme(
    ThemeData.dark().textTheme,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0x898989),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: const BorderSide(color: Color(0xFF898989)),
      ),
    ),
  ), colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
  ).copyWith(
    secondary: Colors.blueAccent, // Add more custom colors if needed
    background: Colors.black,
    // other properties...
  ).copyWith(background: Colors.black),
);

// Extension to add custom properties to ColorScheme
extension CustomColorScheme on ColorScheme {
  Color get googleButtonBackground => brightness == Brightness.light ? Colors.white : Colors.grey[800]!;
}
