import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/controllers/goal_controller.dart';
import 'package:eco_saver/utils/input_decoration.dart'; // Import your custom input decoration function
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditGoalPage extends StatelessWidget {
  final String goalId;
  final GoalController goalController = Get.find<GoalController>();
  final ColorController colorController = Get.find<ColorController>();

  final TextEditingController goalNameController = TextEditingController();
  final TextEditingController targetAmountController = TextEditingController();
  final TextEditingController amountSavedController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  EditGoalPage({super.key, required this.goalId}) {
    // Initialize the controllers with the current goal data
    final goal = goalController.goalsMap[goalId];
    if (goal != null) {
      goalNameController.text = goal.goalName;
      targetAmountController.text = goal.targetAmount.toString();
      amountSavedController.text = goal.amountSaved.toString();
      notesController.text = goal.notes ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Goal',
          style: TextStyle(
              color: colorController.colorScheme.value.onSecondary,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: goalNameController,
                decoration: customInputDecoration(
                  labelText: 'Goal Name',
                  borderColor: colorController.colorScheme.value.onSecondary,
                  focusedBorderColor:
                      colorController.colorScheme.value.secondary,
                  focusedLabelColor:
                      colorController.colorScheme.value.onSecondary,
                ),
                style: TextStyle(
                    color: colorController.colorScheme.value.onSecondary),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: targetAmountController,
                keyboardType: TextInputType.number,
                decoration: customInputDecoration(
                  labelText: 'Target Amount',
                  borderColor: colorController.colorScheme.value.onSecondary,
                  focusedBorderColor:
                      colorController.colorScheme.value.secondary,
                  focusedLabelColor:
                      colorController.colorScheme.value.onSecondary,
                  prefixText: "\$ ",
                ),
                style: TextStyle(
                    color: colorController.colorScheme.value.onSecondary),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a target amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: amountSavedController,
                keyboardType: TextInputType.number,
                decoration: customInputDecoration(
                  labelText: 'Amount Saved',
                  borderColor: colorController.colorScheme.value.onSecondary,
                  focusedBorderColor:
                      colorController.colorScheme.value.secondary,
                  focusedLabelColor:
                      colorController.colorScheme.value.onSecondary,
                  prefixText: "\$ ",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount saved';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                style: TextStyle(
                    color: colorController.colorScheme.value.onSecondary),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: notesController,
                decoration: customInputDecoration(
                  labelText: 'Notes',
                  borderColor: colorController.colorScheme.value.onSecondary,
                  focusedBorderColor:
                      colorController.colorScheme.value.secondary,
                  focusedLabelColor:
                      colorController.colorScheme.value.onSecondary,
                ),
                style: TextStyle(
                    color: colorController.colorScheme.value.onSecondary),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveGoal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorController.colorScheme.value.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    'Save Goal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorController.colorScheme.value.onSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveGoal() {
    // Update the goal with the new values
    final String goalName = goalNameController.text.trim();
    final double targetAmount =
        double.tryParse(targetAmountController.text.trim()) ?? 0.0;
    final double amountSaved =
        double.tryParse(amountSavedController.text.trim()) ?? 0.0;
    final String? notes = notesController.text.trim().isEmpty
        ? null
        : notesController.text.trim();

    goalController
        .updateGoal(
      goalId: goalId,
      goalName: goalName,
      targetAmount: targetAmount,
      amountSaved: amountSaved,
      notes: notes,
    )
        .then((_) {
      Get.back(); // Go back to the previous page after saving
    }).catchError((error) {
      // Handle the error if needed
      // ignore: avoid_print
      print('Failed to update goal: $error');
    });
  }
}
