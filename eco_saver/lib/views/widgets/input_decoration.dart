// import 'package:flutter/material.dart';

// class CustomInputDecoration {
//   final String labelText;
//   final Color borderColor;
//   final Color focusedBorderColor;
//   final Color focusedLabelColor;
//   final String? prefixText;

//   CustomInputDecoration({
//     required this.labelText,
//     required this.borderColor,
//     required this.focusedBorderColor,
//     required this.focusedLabelColor,
//     this.prefixText,
//   });

//   InputDecoration customInputDecoration() {
//     return InputDecoration(
//       labelText: labelText,
//       prefixText: prefixText,
//       hintStyle: const TextStyle(fontWeight: FontWeight.normal),
//       contentPadding:
//           const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30.0),
//         borderSide: BorderSide(color: borderColor),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30.0),
//         borderSide: BorderSide(color: borderColor),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30.0),
//         borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
//       ),
//       floatingLabelStyle: TextStyle(
//         color: focusedLabelColor,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
// }
