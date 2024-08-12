import 'package:eco_saver/controllers/color_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CustomCardPattern extends StatelessWidget {
  CustomCardPattern({super.key, required this.child});
  final ColorController colorController = Get.find<ColorController>();
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: colorController.colorScheme.value.shadow,
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3), // Changes position of shadow
            ),
          ],
          color: colorController.colorScheme.value.surface,
        ),
        child: child,
      ),
    );
  }
}
