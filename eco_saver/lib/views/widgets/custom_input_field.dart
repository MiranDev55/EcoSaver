import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final ValueChanged<String> onChanged;

  const CustomInputField({
    super.key,
    required this.label,
    this.isPassword = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
