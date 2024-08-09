import 'package:eco_saver/controllers/color_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({super.key, required this.title});
  final ColorController _colorController = Get.find<ColorController>();
  final String title;

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
      actions: const [Icon(Icons.settings)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
