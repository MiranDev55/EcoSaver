import 'package:eco_saver/controllers/color_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar2({super.key, required this.title, this.actions});

  final ColorController _colorController = Get.find<ColorController>();
  final String title;
  final List<Widget>? actions; // Add nullable actions

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _colorController.colorScheme.value.surface,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: _colorController.colorScheme.value.onSecondary,
        ),
      ),
      actions: actions, // Add actions to AppBar
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
