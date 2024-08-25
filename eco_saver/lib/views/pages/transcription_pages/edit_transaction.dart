import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/models/category.dart';
import 'package:eco_saver/models/expense.dart';
import 'package:eco_saver/models/income.dart';
import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/services/expenses_service.dart';
import 'package:eco_saver/services/incomes_service.dart';
import 'package:eco_saver/utils/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class EditTransactionPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final IncomeController incomeController = Get.find<IncomeController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final ColorController _colorController = Get.find<ColorController>();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final Expense? expense;
  final Income? income;
  final String title;

  String? selectedCategory;

  EditTransactionPage({
    super.key,
    this.expense,
    this.income,
    required this.title,
  }) {
    if (expense != null) {
      amountController.text = expense!.amount.toString();
      notesController.text = expense!.notes ?? '';
      dateController.text = DateFormat('yyyy-MM-dd').format(expense!.date);
      timeController.text = DateFormat('HH:mm').format(expense!.date);
      selectedCategory = expense!.category;
    } else if (income != null) {
      amountController.text = income!.amount.toString();
      notesController.text = income!.notes ?? '';
      dateController.text = DateFormat('yyyy-MM-dd').format(income!.date);
      timeController.text = DateFormat('HH:mm').format(income!.date);
      selectedCategory = income!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title),
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
                          initialDate: expense?.date ?? income!.date,
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
                  const SizedBox(width: 20),
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
                          initialTime: TimeOfDay.fromDateTime(
                              expense?.date ?? income!.date),
                        );

                        if (pickedTime != null) {
                          final now = DateTime.now();
                          final pickedDateTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          timeController.text =
                              DateFormat('HH:mm').format(pickedDateTime);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: notesController,
                decoration: customInputDecoration(
                    labelText: 'Notes',
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
                      _updateTransaction();
                      Get.back(); // Go back after updating
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
                    'Update Transaction',
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

  List<DropdownMenuItem<String>> category() {
    if (expense != null) {
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

  void _updateTransaction() {
    // Parse date separately
    DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(dateController.text);

    // Parse time separately using a 24-hour format
    TimeOfDay selectedTime = TimeOfDay(
      hour: int.parse(timeController.text.split(":")[0]),
      minute: int.parse(timeController.text.split(":")[1]),
    );

    // Convert TimeOfDay to 24-hour format
    DateTime finalDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (expense != null) {
      Expense updatedExpense = expense!;
      updatedExpense.amount = double.parse(amountController.text.trim());
      updatedExpense.category = selectedCategory ?? expense!.category;
      updatedExpense.date = finalDateTime;
      updatedExpense.notes = notesController.text.trim();

      expenseController.updateExpense(updatedExpense, "");
    } else if (income != null) {
      Income updatedIncome = income!;
      updatedIncome.amount = double.parse(amountController.text.trim());
      updatedIncome.category = selectedCategory ?? income!.category;
      updatedIncome.date = finalDateTime;
      updatedIncome.notes = notesController.text.trim();

      incomeController.updateIncome(updatedIncome, "");
    }
  }
}
