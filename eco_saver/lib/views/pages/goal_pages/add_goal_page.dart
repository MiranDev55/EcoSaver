import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/controllers/goal_controller.dart';
import 'package:eco_saver/utils/input_decoration.dart';
import 'package:eco_saver/views/widgets/appbar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddGoalPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GoalController goalController = Get.find<GoalController>();
  final ColorController _colorController = Get.find<ColorController>();

  final TextEditingController goalNameController = TextEditingController();
  final TextEditingController targetAmountController = TextEditingController();
  final TextEditingController amountSavedController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final bool isNewGoal;

  AddGoalPage({super.key, required this.isNewGoal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorController.colorScheme.value.surface,
      appBar: CustomAppBar2(title: "Add Goal"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              TextFormField(
                controller: goalNameController,
                decoration: customInputDecoration(
                    labelText: 'Goal Name',
                    borderColor: _colorController.colorScheme.value.onSecondary,
                    focusedBorderColor:
                        _colorController.colorScheme.value.secondary,
                    focusedLabelColor:
                        _colorController.colorScheme.value.onSecondary),
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
                    borderColor: _colorController.colorScheme.value.onSecondary,
                    focusedBorderColor:
                        _colorController.colorScheme.value.secondary,
                    prefixText: "\$ ",
                    focusedLabelColor:
                        _colorController.colorScheme.value.onSecondary),
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
                    labelText: 'Amount Saved (optional)',
                    borderColor: _colorController.colorScheme.value.onSecondary,
                    focusedBorderColor:
                        _colorController.colorScheme.value.secondary,
                    prefixText: "\$ ",
                    focusedLabelColor:
                        _colorController.colorScheme.value.onSecondary),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: notesController,
                decoration: customInputDecoration(
                    labelText: 'Notes (optional)',
                    borderColor: _colorController.colorScheme.value.onSecondary,
                    focusedBorderColor:
                        _colorController.colorScheme.value.secondary,
                    focusedLabelColor:
                        _colorController.colorScheme.value.onSecondary),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addGoal();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _colorController.colorScheme.value.secondary,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(String title) {
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
    );
  }

  void addGoal() {
    final String goalName = goalNameController.text.trim();
    final double targetAmount =
        double.parse(targetAmountController.text.trim());
    final double amountSaved = amountSavedController.text.isNotEmpty
        ? double.parse(amountSavedController.text.trim())
        : 0.0;
    final String? notes = notesController.text.trim().isEmpty
        ? null
        : notesController.text.trim();

    goalController
        .addGoal(
      goalName: goalName,
      targetAmount: targetAmount,
      amountSaved: amountSaved,
      notes: notes,
    )
        .then((_) {
      Get.back(); // Close the form page after submitting
    });
  }
}
