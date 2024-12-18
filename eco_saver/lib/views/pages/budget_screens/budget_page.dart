import 'package:eco_saver/controllers/budget_controller.dart';
import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/utils/input_decoration.dart';
import 'package:eco_saver/views/widgets/appbar1.dart';
import 'package:eco_saver/views/pages/budget_screens/budget_widgets/budget_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BudgetPage extends StatelessWidget {
  final ColorController colorController = Get.find<ColorController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final BudgetController budgetController = Get.find<BudgetController>();

  BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        title: "Budget",
      ),
      backgroundColor: colorController.colorScheme.value.surface,
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextButton(
                          onPressed: () => _showAddBudgetDialog(context),
                          child: Text(
                            "Add new Budget",
                            style: TextStyle(
                                color:
                                    colorController.colorScheme.value.primary),
                          )),
                    ),
                  ],
                ),
                Column(
                  children: [
                    BudgetList(
                      categoryController: categoryController,
                      budgetController: budgetController,
                      colorController: colorController,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    final TextEditingController budgetTextController = TextEditingController();
    String? selectedCategory;

    Get.dialog(
      AlertDialog(
        title: Text(
          'Add New Budget',
          style: TextStyle(color: colorController.colorScheme.value.primary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: customInputDecoration(
                labelText: 'Select Category',
                borderColor: colorController.colorScheme.value.onSecondary,
                focusedBorderColor: colorController.colorScheme.value.secondary,
                focusedLabelColor:
                    colorController.colorScheme.value.onSecondary,
              ),
              style:
                  TextStyle(color: colorController.colorScheme.value.primary),
              items: categoryController.expenseCategories
                  .map((category) => DropdownMenuItem<String>(
                        value: category.name,
                        child: Text(category.name),
                      ))
                  .toList(),
              onChanged: (value) {
                selectedCategory = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: budgetTextController,
              keyboardType: TextInputType.number,
              decoration: customInputDecoration(
                labelText: 'Budget Amount',
                borderColor: colorController.colorScheme.value.onSecondary,
                focusedBorderColor: colorController.colorScheme.value.secondary,
                focusedLabelColor:
                    colorController.colorScheme.value.onSecondary,
              ),
              style: TextStyle(
                color: colorController.colorScheme.value.onSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text(
              'Cancel',
              style:
                  TextStyle(color: colorController.colorScheme.value.secondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedCategory != null) {
                double amount =
                    double.tryParse(budgetTextController.text) ?? 0.0;
                budgetController.createBudget(selectedCategory!, amount);
                Get.back(); // Close the dialog after saving
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorController.colorScheme.value.secondary,
              foregroundColor: colorController.colorScheme.value.onSecondary,
            ),
            child: const Text('Add Budget'),
          ),
        ],
      ),
    );
  }
}
