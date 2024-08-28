import 'package:eco_saver/controllers/budget_controller.dart';
import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/utils/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BudgetList extends StatelessWidget {
  final ColorController colorController;
  final CategoryController categoryController;
  final BudgetController budgetController;

  const BudgetList({
    super.key,
    required this.categoryController,
    required this.budgetController,
    required this.colorController,
  });

  @override
  Widget build(BuildContext context) {
    // Filter categories that have a non-zero budget
    final filteredCategories =
        categoryController.expenseCategories.where((category) {
      return (budgetController.budgets[category.name] ?? 0.0) > 0.0;
    }).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredCategories.length,
      itemBuilder: (context, index) {
        final category = filteredCategories[index];

        return Obx(() {
          double budget = budgetController.budgets[category.name] ?? 0.0;
          double spent = budgetController.spent[category.name] ?? 0.0;
          double spentPercentage = budget > 0 ? spent / budget : 0.0;

          return ExpansionTile(
            leading: Icon(
              category.icon,
            ),
            iconColor: colorController.colorScheme.value.secondary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorController.colorScheme.value.onSecondary),
                ),
                Text(
                  "\$${budget.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorController.colorScheme.value.onSecondary),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  child: Row(
                    children: [
                      Expanded(
                        flex: (spentPercentage * 100).toInt(),
                        child: Container(
                          height: 8,
                          color: colorController.colorScheme.value.secondary,
                        ),
                      ),
                      Expanded(
                        flex: ((1 - spentPercentage) * 100).toInt(),
                        child: Container(
                          height: 8,
                          color: colorController.colorScheme.value.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "spent: \$${spent.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: colorController.colorScheme.value.onSecondary),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _showEditBudgetDialog(
                            context, category.name, budgetController);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorController.colorScheme.value
                            .secondary, // Custom color for button background
                        foregroundColor: colorController.colorScheme.value
                            .onSecondary, // Custom color for button text
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        budgetController.deleteBudget(category.name);
                        Get.back(); // Close the expansion tile (optional)
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.pink),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          );
        });
      },
    );
  }

  void _showEditBudgetDialog(BuildContext context, String categoryName,
      BudgetController budgetController) {
    final TextEditingController budgetTextController = TextEditingController(
        text: (budgetController.budgets[categoryName] ?? 0.0).toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Budget for $categoryName"),
          content: TextField(
            controller: budgetTextController,
            keyboardType: TextInputType.number,
            decoration: customInputDecoration(
                labelText: "Budget amount",
                borderColor: colorController.colorScheme.value.onSecondary,
                focusedBorderColor: colorController.colorScheme.value.secondary,
                focusedLabelColor:
                    colorController.colorScheme.value.onSecondary),
            style: TextStyle(
              color: colorController
                  .colorScheme.value.onSecondary, // Custom color for text
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Get.back(); // Close the dialog
              },
            ),
            ElevatedButton(
              onPressed: () {
                double newBudget =
                    double.tryParse(budgetTextController.text) ?? 0.0;
                budgetController.updateBudget(categoryName, newBudget);
                Get.back(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorController.colorScheme.value.secondary,
                foregroundColor: colorController.colorScheme.value.onSecondary,
              ),
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
