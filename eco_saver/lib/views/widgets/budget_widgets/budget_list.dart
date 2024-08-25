import 'package:eco_saver/controllers/color_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/controllers/budget_controller.dart';

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

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredCategories.length,
      itemBuilder: (context, index) {
        final category = filteredCategories[index];
        return Obx(() {
          double budget = budgetController.budgets[category.name] ?? 0.0;
          double spent = budgetController.spent[category.name] ?? 0.0;
          //double remaining = budgetController.remainingBudget(category.name);
          double spentPercentage = budget > 0 ? spent / budget : 0.0;

          return ExpansionTile(
            leading: Icon(category.icon),
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
                      //fontSize: 20,
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
              ListTile(
                title: const Text("Edit Budget"),
                trailing: const Icon(Icons.edit),
                onTap: () {
                  _showBudgetDialog(context, category.name);
                },
              ),
            ],
          );
        });
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 3,
          endIndent: 20,
          indent: 20,
        );
      },
    );
  }

  // Show a dialog to set the budget for a category
  void _showBudgetDialog(BuildContext context, String category) {
    final TextEditingController budgetTextController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Set Budget for $category"),
          content: TextField(
            controller: budgetTextController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Budget Amount",
              hintText: "Enter amount",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                double amount =
                    double.tryParse(budgetTextController.text) ?? 0.0;
                if (budgetController.budgets.containsKey(category)) {
                  // If the budget for this category already exists, update it
                  budgetController.updateBudget(category, amount);
                } else {
                  // If the budget for this category does not exist, create it
                  budgetController.createBudget(category, amount);
                }
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
