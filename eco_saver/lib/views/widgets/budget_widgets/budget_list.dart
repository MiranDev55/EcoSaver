import 'package:eco_saver/controllers/budget_controller.dart';
import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/models/budget.dart';
import 'package:eco_saver/views/pages/budget_screens/budget_edit.dart';
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
      return (budgetController.budgets[category.name]?.budget ?? 0.0) > 0.0;
    }).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredCategories.length,
      itemBuilder: (context, index) {
        final category = filteredCategories[index];

        return Obx(() {
          Budget? budgetObj = budgetController.budgets[category.name];
          double budget = budgetObj?.budget ?? 0.0;
          double spent = budgetController.spent[category.name] ?? 0.0;
          double spentPercentage = budget > 0 ? spent / budget : 0.0;

          return GestureDetector(
            onTap: () {
              // Navigate to the new budget edit page when tapped
              Get.to(() => BudgetEditPage(
                    categoryName: category.name,
                    budget: budget,
                    spent: spent,
                    colorController: colorController,
                  ));
            },
            child: Card(
              elevation: 4,
              color: colorController.colorScheme.value.primaryContainer,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          category.icon,
                          color: colorController.colorScheme.value.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            category.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color:
                                  colorController.colorScheme.value.onSecondary,
                            ),
                          ),
                        ),
                        Text(
                          "\$${budget.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color:
                                colorController.colorScheme.value.onSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      child: Row(
                        children: [
                          Expanded(
                            flex: (spentPercentage * 100).toInt(),
                            child: Container(
                              height: 8,
                              color: Colors.yellow, // Spent portion in yellow
                            ),
                          ),
                          Expanded(
                            flex: ((1 - spentPercentage) * 100).toInt(),
                            child: Container(
                              height: 8,
                              color: colorController.colorScheme.value
                                  .primary, // Remaining budget in primary color
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Spent: \$${spent.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: colorController.colorScheme.value.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
