// goal_page.dart
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/controllers/goal_controller.dart';
import 'package:eco_saver/views/pages/goal_pages/add_goal_page.dart';
import 'package:eco_saver/views/widgets/appbar1.dart';
import 'package:eco_saver/utils/custom_container.dart';
import 'package:eco_saver/views/pages/goal_pages/goal_widgets.dart/goal_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalPage extends StatelessWidget {
  GoalPage({super.key});

  final ColorController _colorController = Get.find<ColorController>();
  final GoalController _goalController =
      Get.put(GoalController()); // Initialize GoalController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        title: "Goal Page",
      ),
      backgroundColor: _colorController.colorScheme.value.surface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.to(() => AddGoalPage(isNewGoal: true));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _colorController.colorScheme.value.secondary,
                  foregroundColor:
                      _colorController.colorScheme.value.onSecondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  'Add Goal',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _colorController.colorScheme.value.onSecondary),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
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
                      "How much do I still need to save?",
                      style: TextStyle(
                        fontSize: 14,
                        color: _colorController.colorScheme.value.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                // Listen to changes in the goalsMap from GoalController
                if (_goalController.goalsMap.isEmpty) {
                  return CustomContainer(
                    child: Center(
                      child: Text(
                        "No goals found",
                        style: TextStyle(
                          fontSize: 16,
                          color: _colorController.colorScheme.value.onSurface,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _goalController.goalsMap.length,
                  itemBuilder: (context, index) {
                    final goal =
                        _goalController.goalsMap.values.toList()[index];
                    return GoalTile(
                      goal: goal,
                      colorController: _colorController,
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
