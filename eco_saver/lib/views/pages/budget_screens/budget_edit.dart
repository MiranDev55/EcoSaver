import 'package:eco_saver/controllers/budget_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/views/pages/budget_screens/budget_widgets/budget_pie_chart.dart';
import 'package:eco_saver/views/widgets/appbar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BudgetEditPage extends StatelessWidget {
  final ColorController colorController;
  final BudgetController budgetController = Get.find<BudgetController>();
  final String categoryName;
  final double budget;
  final double spent;

  BudgetEditPage({
    super.key,
    required this.categoryName,
    required this.budget,
    required this.spent,
    required this.colorController,
  });

  final TextEditingController budgetTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    budgetTextController.text =
        budget.toString(); // Initialize with current budget

    return Scaffold(
      appBar: CustomAppBar2(
        title: "Budget for $categoryName",
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _confirmDelete(); // Call delete confirmation dialog
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: colorController.colorScheme.value.surface,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current Budget: \$${budget.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: colorController.colorScheme.value.onSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Spent: \$${spent.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    color: colorController.colorScheme.value.onSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                BudgetPieChart(
                  spent: spent,
                  budget: budget,
                  colorController: colorController,
                ), // Use the new pie chart here
                const SizedBox(height: 20),
                TextFormField(
                  controller: budgetTextController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "New Budget Amount",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: colorController.colorScheme.value.onSecondary,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: colorController.colorScheme.value.secondary,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: colorController.colorScheme.value.onSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _updateBudget(); // Call update function when the button is pressed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        colorController.colorScheme.value.secondary,
                    foregroundColor:
                        colorController.colorScheme.value.onSecondary,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Update Budget"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to update the budget
  void _updateBudget() {
    double newBudget = double.tryParse(budgetTextController.text) ?? 0.0;
    if (newBudget > 0) {
      // Update the budget using the budgetController
      budgetController.updateBudget(categoryName, newBudget);
      Get.back(); // Go back to the previous screen after updating
    } else {
      Get.snackbar(
        'Error',
        'Please enter a valid budget amount',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Function to show a confirmation dialog before deleting the budget
  void _confirmDelete() => Get.dialog(
        AlertDialog(
          title: Column(
            children: [
              Icon(Icons.delete_outline,
                  size: 50, color: colorController.colorScheme.value.secondary),
              const SizedBox(height: 10),
              Text(
                'Delete Budget',
                style: TextStyle(
                  color: colorController.colorScheme.value.secondary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Deleting this budget will permanently remove it from your data.',
            style: TextStyle(
                fontSize: 16,
                color: colorController.colorScheme.value.onSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Text(
                'No, Keep Budget',
                style: TextStyle(
                  color: colorController.colorScheme.value.onSecondary
                      .withOpacity(0.75),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteBudget(); // Call delete function
                Get.back(); // Close the dialog
                Get.back(); // Go back to the previous screen
              },
              child: const Text(
                'Yes, Delete Budget',
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ],
        ),
      );

  // Function to delete the budget
  void _deleteBudget() {
    budgetController.deleteBudget(categoryName);
    Get.snackbar(
      'Deleted',
      'The budget for $categoryName has been deleted',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
