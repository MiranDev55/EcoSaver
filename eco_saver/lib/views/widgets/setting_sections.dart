import 'package:eco_saver/controllers/color_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colorController = Get.find<ColorController>();

    return Container(
      width: double.infinity, // Ensures the container takes the full width
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // Grey background color
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: colorController.colorScheme.value.onSecondary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorController = Get.find<ColorController>();

    return ListTile(
      leading: Icon(
        icon,
        color: colorController.colorScheme.value.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(color: colorController.colorScheme.value.onSecondary),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: colorController.colorScheme.value.onSurface,
      ),
      onTap: onTap,
    );
  }
}
