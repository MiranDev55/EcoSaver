import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ColorController extends GetxController {
  // Initialize the ColorScheme with specific colors
  final Rx<ColorScheme> colorScheme = Rx<ColorScheme>(
    const ColorScheme(
        brightness: Brightness.light,
        primary: Color.fromRGBO(69, 71, 75, 1), // Custom primary color
        onPrimary: Colors.white, // Text color on primary background

        secondary: Color.fromRGBO(244, 206, 20, 1), // Custom secondary color
        onSecondary:
            Color.fromRGBO(73, 94, 87, 1), // Text color on secondary background

        error: Colors.red, // Default fallback for error color
        onError: Colors.white, // Text color on error background

        background: Colors.white, // Background color of scaffold
        onBackground:
            Color.fromRGBO(73, 94, 87, 1), // Text color on background color

        surface: Color.fromRGBO(
            245, 247, 248, 1), // Background color of Card, Dialog, etc.
        onSurface: Color.fromRGBO(73, 94, 87, 1), // Text color on surface color

        shadow: Color.fromRGBO(158, 158, 158, 0.5)),
  );

  // Function to update the primary color
  void updatePrimaryColor(Color newPrimaryColor) {
    colorScheme.value = colorScheme.value.copyWith(primary: newPrimaryColor);
  }

  // Function to update the secondary color
  void updateSecondaryColor(Color newSecondaryColor) {
    colorScheme.value =
        colorScheme.value.copyWith(secondary: newSecondaryColor);
  }
}
