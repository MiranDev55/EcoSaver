import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/controllers/goal_controller.dart';
import 'package:eco_saver/models/goals.dart';
import 'package:eco_saver/views/pages/goal_pages/edit_goal_page.dart';
import 'package:eco_saver/views/pages/goal_pages/goal_widgets.dart/goal_calculator.dart';
import 'package:eco_saver/views/widgets/appbar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalDetails extends StatelessWidget {
  final String goalId;
  final ColorController colorController = Get.find<ColorController>();
  final GoalController goalController = Get.find<GoalController>();

  GoalDetails({super.key, required this.goalId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(
        title: "Goal Details",
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.to(() => EditGoalPage(goalId: goalId));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Get.defaultDialog(
                title: '',
                content: Column(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 50,
                      color: colorController.colorScheme.value.secondary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Delete Goal',
                      style: TextStyle(
                        color: colorController.colorScheme.value.secondary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Deleting a goal will permanently remove it from your library.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: colorController
                            .colorScheme.value.onSurface, // Text color
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.back(); // Close the dialog
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[
                              200], // Background color for the cancel button
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: Text(
                          'No, Keep Goal',
                          style: TextStyle(
                            color: colorController.colorScheme.value.onSurface
                                .withOpacity(0.75), // Text color
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          goalController.deleteGoal(goalId).then((_) {
                            Get.back(); // Close the dialog
                            Get.back(); // Navigate back to the previous screen
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              colorController.colorScheme.value.secondary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: Text(
                          'Yes, Delete Goal',
                          style: TextStyle(
                              color: colorController
                                  .colorScheme.value.onSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
                radius: 10.0, // Rounded corners for the dialog
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final goal = goalController.goalsMap[goalId];
          if (goal == null) {
            return const Center(child: Text("Goal not found"));
          }
          double progressPercentage = goal.amountSaved / goal.targetAmount;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor:
                        colorController.colorScheme.value.secondary,
                    child: Icon(Icons.directions_car,
                        color: colorController.colorScheme.value.onSecondary,
                        size: 30),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    goal.goalName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: colorController.colorScheme.value.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildProgressIndicator(progressPercentage),
              const SizedBox(height: 24),
              _buildGoalStatistics(goal),
              const SizedBox(height: 16),
              if (goal.notes != null && goal.notes!.isNotEmpty)
                _buildNotesSection(goal.notes!),
              const Spacer(),
              _buildAddSavedAmountButton(context, goal),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildProgressIndicator(double progressPercentage) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: progressPercentage,
            backgroundColor: colorController.colorScheme.value.primary,
            color: colorController.colorScheme.value.secondary,
            strokeWidth: 10,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(progressPercentage * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorController.colorScheme.value.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGoalStatistics(Goal goal) {
    return Text(
      '${goal.amountSaved.toInt()} / ${goal.targetAmount.toInt()} \$',
      style: TextStyle(
        fontSize: 16,
        color: colorController.colorScheme.value.onSurface,
      ),
    );
  }

  Widget _buildNotesSection(String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Note',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorController.colorScheme.value.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            notes,
            style: TextStyle(
              fontSize: 16,
              color: colorController.colorScheme.value.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddSavedAmountButton(BuildContext context, Goal goal) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.dialog(CalculatorPopup(
            onAmountEntered: (enteredAmount) {
              double newAmountSaved = goal.amountSaved + enteredAmount;

              goalController.updateGoal(
                goalId: goal.id,
                amountSaved: newAmountSaved,
              );
            },
            colorController: colorController,
          ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorController.colorScheme.value.secondary,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'ADD SAVED AMOUNT',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: colorController.colorScheme.value.onSecondary),
        ),
      ),
    );
  }
}
