import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/models/category.dart';
import 'package:eco_saver/models/expense.dart';
import 'package:eco_saver/services/expenses_service.dart';
import 'package:eco_saver/controllers/category_controller.dart'; // Make sure this is correctly imported
import 'package:eco_saver/utils/input_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AddExpensePage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final ColorController _colorController = Get.find<ColorController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  String? selectedCategory;

  AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Add New Expense'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.number,
                decoration: customInputDecoration(
                    labelText: 'Name',
                    borderColor: _colorController.colorScheme.value.onSecondary,
                    focusedBorderColor:
                        _colorController.colorScheme.value.secondary,
                    focusedLabelColor:
                        _colorController.colorScheme.value.onSecondary),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an name of the expense';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: customInputDecoration(
                    labelText: 'Amount',
                    borderColor: _colorController.colorScheme.value.onSecondary,
                    focusedBorderColor:
                        _colorController.colorScheme.value.secondary,
                    prefixText: "\$ ",
                    focusedLabelColor:
                        _colorController.colorScheme.value.onSecondary),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: customInputDecoration(
                    labelText: 'Category',
                    borderColor: _colorController.colorScheme.value.onSecondary,
                    focusedBorderColor:
                        _colorController.colorScheme.value.secondary,
                    focusedLabelColor:
                        _colorController.colorScheme.value.onSecondary),
                items: categoryController.categories.map((Category category) {
                  return DropdownMenuItem<String>(
                    value: category.name,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  selectedCategory = newValue;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextField(
                  controller: notesController,
                  decoration: customInputDecoration(
                      labelText: 'Notes',
                      borderColor:
                          _colorController.colorScheme.value.onSecondary,
                      focusedBorderColor:
                          _colorController.colorScheme.value.secondary,
                      focusedLabelColor:
                          _colorController.colorScheme.value.onSecondary)),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Expense newExpense = Expense(
                          userId:
                              userId ?? '', // Ensure this is a non-null string
                          amount: double.parse(amountController.text.trim()),
                          category: selectedCategory ??
                              '', // Use the selected category
                          date: DateTime.now(),
                          notes: notesController.text.trim(),
                          createdAt: DateTime.now(),
                          name: nameController.text);
                      expenseController.createExpense(newExpense).then((_) {
                        Get.back(); // Close the form page after submitting
                      });
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
                    'Add Expense',
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
}