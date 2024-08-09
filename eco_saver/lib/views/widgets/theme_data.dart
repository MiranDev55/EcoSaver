import 'package:flutter/material.dart';

class ThemeData22 {
  var x = ThemeData(
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 64.0, // Large text for splash screens or banners
        fontWeight: FontWeight.bold,
        letterSpacing: -1.5,
      ),
      displayMedium: TextStyle(
        fontSize: 48.0, // Slightly smaller large text for big headers
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      headlineLarge: TextStyle(
        fontSize: 32.0, // Major section headers
        fontWeight: FontWeight.bold,
        letterSpacing: 0.0,
      ),
      headlineMedium: TextStyle(
        fontSize: 28.0, // Secondary headers within sections
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
      ),
      titleLarge: TextStyle(
        fontSize: 24.0, // Titles within cards or panels
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      titleMedium: TextStyle(
        fontSize: 20.0, // Subtitle text or smaller titles
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.0, // Primary body text, larger than normal
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.0, // Default body text for most paragraphs
        fontWeight: FontWeight.normal,
        letterSpacing: 0.25,
      ),
    ),
  );
}
