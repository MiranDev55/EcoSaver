import 'package:eco_saver/controllers/budget_controller.dart';
import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/utils/custom_container.dart';
import 'package:eco_saver/utils/input_decoration.dart';
import 'package:eco_saver/views/widgets/app_bar.dart';
import 'package:eco_saver/views/widgets/budget_widgets/budget_list.dart';
import 'package:eco_saver/views/widgets/budget_widgets/budget_pie.dart';
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
      appBar: CustomAppBar(
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
                CustomContainer(
                  child: BudgetPie(
                    categoryController: categoryController,
                    colorController: colorController,
                  ),
                ),
                CustomContainer(
                  child: Column(
                    children: [
                      BudgetList(
                        categoryController: categoryController,
                        budgetController: budgetController,
                        colorController: colorController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showAddBudgetDialog(context);
      //   },
      //   backgroundColor: colorController.colorScheme.value.secondary,
      //   child: Icon(
      //     Icons.add,
      //     color: colorController.colorScheme.value.onSecondary,
      //   ),
      // ),
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    final TextEditingController budgetTextController = TextEditingController();
    String? selectedCategory;

    Get.dialog(
      AlertDialog(
        title: const Text('Add New Budget'),
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
