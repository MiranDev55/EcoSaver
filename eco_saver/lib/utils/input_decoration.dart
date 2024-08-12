import 'package:flutter/material.dart';

InputDecoration customInputDecoration({
  required String labelText,
  required Color borderColor,
  required Color focusedBorderColor,
  required Color focusedLabelColor, // Add this parameter
  String? prefixText,
}) {
  return InputDecoration(
    labelText: labelText,
    prefixText: prefixText,
    hintStyle: const TextStyle(fontWeight: FontWeight.normal),
    contentPadding:
        const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
    ),
    floatingLabelStyle: TextStyle(
      // Set the style for the floating label
      color: focusedLabelColor,
      fontWeight: FontWeight.bold, // Optional: Customize as needed
    ),
  );
}
