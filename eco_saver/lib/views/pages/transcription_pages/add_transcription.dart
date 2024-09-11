import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/models/category.dart';
import 'package:eco_saver/models/expense.dart';
import 'package:eco_saver/models/income.dart';
import 'package:eco_saver/services/expenses_service.dart';
import 'package:eco_saver/controllers/category_controller.dart'; // Make sure this is correctly imported
import 'package:eco_saver/services/incomes_service.dart';
import 'package:eco_saver/utils/input_decoration.dart';
import 'package:eco_saver/views/widgets/appbar2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AddExpensePage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final IncomeController incomeController = Get.find<IncomeController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final ColorController _colorController = Get.find<ColorController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  TextEditingController dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController timeController = TextEditingController(
    text: DateFormat('HH:mm').format(DateTime.now()),
  );

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  final bool isAddExpense;
  final String title;

  String? selectedCategory;

  AddExpensePage({super.key, required this.isAddExpense, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(title: title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
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
                items: category(),
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: dateController,
                      readOnly: true,
                      decoration: customInputDecoration(
                        labelText: 'Date',
                        borderColor:
                            _colorController.colorScheme.value.onSecondary,
                        focusedBorderColor:
                            _colorController.colorScheme.value.secondary,
                        focusedLabelColor:
                            _colorController.colorScheme.value.onSecondary,
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          dateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 20), // Space between the fields
                  Expanded(
                    child: TextFormField(
                      controller: timeController,
                      readOnly: true,
                      decoration: customInputDecoration(
                        labelText: 'Time',
                        borderColor:
                            _colorController.colorScheme.value.onSecondary,
                        focusedBorderColor:
                            _colorController.colorScheme.value.secondary,
                        focusedLabelColor:
                            _colorController.colorScheme.value.onSecondary,
                      ),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          timeController.text =
                              DateFormat('HH:mm').format(DateTime.now());
                        }
                      },
                    ),
                  ),
                ],
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
                      addTransaction();
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

  List<DropdownMenuItem<String>> category() {
    if (isAddExpense) {
      return categoryController.expenseCategories.map((Category category) {
        return DropdownMenuItem<String>(
          value: category.name,
          child: Text(category.name),
        );
      }).toList();
    } else {
      return categoryController.incomeCategories.map((Category category) {
        return DropdownMenuItem<String>(
          value: category.name,
          child: Text(category.name),
        );
      }).toList();
    }
  }

  void addTransaction() {
    // Parse date separately
    DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(dateController.text);

    // Parse time separately using a 24-hour format
    TimeOfDay selectedTime = TimeOfDay(
      hour: int.parse(timeController.text.split(":")[0]),
      minute: int.parse(timeController.text.split(":")[1].split(" ")[0]),
    );

    // Convert TimeOfDay to 24-hour format
    DateTime finalDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    if (isAddExpense) {
      Expense newExpense = Expense(
        userId: userId ?? '', // Ensure this is a non-null string
        amount: double.parse(amountController.text.trim()),
        category: selectedCategory ?? '', // Use the selected category
        date: finalDateTime, // Use the combined DateTime object
        notes: notesController.text.trim(),
        createdAt: DateTime.now(),
      );
      expenseController.createExpense(newExpense).then((_) {
        Get.back(); // Close the form page after submitting
      });
    } else {
      Income newIncome = Income(
        userId: userId ?? '', // Ensure this is a non-null string
        amount: double.parse(amountController.text.trim()),
        category: selectedCategory ?? '', // Use the selected category
        date: finalDateTime, // Use current date and time
        notes: notesController.text.trim(),
        createdAt: DateTime.now(),
      );
      incomeController.createIncome(newIncome).then((_) {
        Get.back(); // Close the form page after submitting
      });
    }
  }
}
