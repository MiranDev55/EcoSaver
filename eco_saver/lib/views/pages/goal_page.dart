// dashboard_page.dart
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/models/goals.dart';
import 'package:eco_saver/views/widgets/app_bar.dart';
import 'package:eco_saver/utils/custom_container.dart';
import 'package:eco_saver/views/widgets/goal_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalPage extends StatelessWidget {
  GoalPage({super.key});

  final ColorController _colorController = Get.find<ColorController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Goal Page",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Goals",
                      style: TextStyle(
                          fontSize: 16,
                          color: _colorController.colorScheme.value.onSurface,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "How much i still need to save ?",
                      style: TextStyle(
                        fontSize: 14,
                        color: _colorController.colorScheme.value.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              CustomContainer(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  GoalTile(
                    goal: Goal(
                        title: "New Home",
                        progressPercentage: 0.62,
                        goalAmount: 62000),
                    colorController: _colorController,
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
