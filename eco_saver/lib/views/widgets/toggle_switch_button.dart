import 'package:eco_saver/controllers/buttons_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectableButton extends StatelessWidget {
  final String text;
  final int index;
  final ButtonsController controller;
  final ColorController colorController;
  final int pageSource; // 0 for category, 1 for analyst

  const SelectableButton({
    super.key,
    required this.text,
    required this.index,
    required this.controller,
    required this.colorController,
    required this.pageSource,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () {
            if (pageSource == 0) {
              controller.updateCategoryToggleSwitch(index);
            } else {
              controller.updateAnalystToggleSwitch(index);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: pageSource == 0
                  ? (controller.categoryToggleSwitch.value == index
                      ? colorController
                          .colorScheme.value.secondary // Selected color
                      : Colors.transparent)
                  : (controller.analystToggleSwitch.value == index
                      ? colorController
                          .colorScheme.value.secondary // Selected color
                      : Colors
                          .transparent), // Transparent for unselected state to blend
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: pageSource == 0
                    ? (controller.categoryToggleSwitch.value == index
                        ? colorController
                            .colorScheme.value.onSecondary // Selected color
                        : colorController.colorScheme.value.onPrimary)
                    : (controller.analystToggleSwitch.value == index
                        ? colorController
                            .colorScheme.value.onSecondary // Selected color
                        : colorController.colorScheme.value
                            .onPrimary), // Dimmed text for unselected
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }
}
