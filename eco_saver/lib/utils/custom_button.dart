import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final Alignment? alignment;
  final ButtonStyle? buttonStyle;
  final double? minWidth;
  final double? minHeight;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.alignment,
    this.buttonStyle,
    this.minWidth,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle ??
          ElevatedButton.styleFrom(
            minimumSize: Size(minWidth ?? double.infinity, minHeight ?? 50),
          ),
      child: icon != null
          ? Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8.0,
              children: [
                Text(
                  text,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(icon),
              ],
            )
          : Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
    );

    if (alignment != null) {
      return Container(
        alignment: alignment,
        child: button,
      );
    }

    return button;
  }
}

class CustomButtonStyle {
  // Base style that can be customized further
  static ButtonStyle baseStyle({
    required ColorScheme colorScheme,
    double? borderRadius,
    double? elevation,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
  }) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(colorScheme.secondary),
      foregroundColor: WidgetStateProperty.all(colorScheme.onSecondary),
      elevation: WidgetStateProperty.all(elevation ?? 2),
      padding: WidgetStateProperty.all(
        padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
        ),
      ),
      minimumSize: WidgetStateProperty.all(minimumSize),
    );
  }

  // Default style, similar to the original `defaultStyle`
  static ButtonStyle defaultStyle(ColorScheme colorScheme) {
    return baseStyle(
      colorScheme: colorScheme,
    );
  }

  // Full-width style for buttons that need to span the width of the container
  static ButtonStyle fullWidthStyle(ColorScheme colorScheme) {
    return baseStyle(
      colorScheme: colorScheme,
      minimumSize: const Size(double.infinity, 50),
    );
  }
}
