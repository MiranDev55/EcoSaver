import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/models/category.dart';
import 'package:eco_saver/models/expense.dart';
import 'package:eco_saver/models/income.dart';
import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/services/expenses_service.dart';
import 'package:eco_saver/services/incomes_service.dart';
import 'package:eco_saver/utils/input_decoration.dart';
import 'package:eco_saver/views/widgets/appbar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  final String id;

  final RxnString selectedCategory = RxnString();

  EditTransactionPage({
    super.key,
    this.expense,
    this.income,
    required this.title,
    required this.id,
  }) {
    if (expense != null) {
      amountController.text = expense!.amount.toString();
      notesController.text = expense!.notes ?? '';
      dateController.text = DateFormat('yyyy-MM-dd').format(expense!.date);
      timeController.text = DateFormat('HH:mm').format(expense!.date);
      selectedCategory.value = expense!.category;
    } else if (income != null) {
      amountController.text = income!.amount.toString();
      notesController.text = income!.notes ?? '';
      dateController.text = DateFormat('yyyy-MM-dd').format(income!.date);
      timeController.text = DateFormat('HH:mm').format(income!.date);
      selectedCategory.value = income!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(title: title),
      backgroundColor: _colorController.colorScheme.value.surface,
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
                value: selectedCategory.value,
                dropdownColor: _colorController.colorScheme.value.surface,
                decoration: customInputDecoration(
                    labelText: 'Category',
                    borderColor: _colorController.colorScheme.value.onSecondary,
                    focusedBorderColor:
                        _colorController.colorScheme.value.secondary,
                    focusedLabelColor:
                        _colorController.colorScheme.value.onSecondary),
                items: category(),
                onChanged: (String? newValue) {
                  selectedCategory.value = newValue;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
                style: TextStyle(
                  color: _colorController
                      .colorScheme.value.primary, // Set text color to primary
                ),
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
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                dialogBackgroundColor: _colorController
                                    .colorScheme
                                    .value
                                    .surface, // Change the background color
                                colorScheme: ColorScheme.light(
                                  primary: _colorController.colorScheme.value
                                      .secondary, // Header background color
                                  onPrimary: Colors.white, // Header text color
                                  onSurface: _colorController.colorScheme.value
                                      .primary, // Body text color
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedDate != null) {
                          dateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        }
                      },
                      style: TextStyle(
                        color: _colorController.colorScheme.value
                            .primary, // Set text color to primary
                      ),
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
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  dialogBackgroundColor: Colors
                                      .blue[50], // Change background color
                                  colorScheme: ColorScheme.light(
                                    primary: _colorController.colorScheme.value
                                        .surface, // Header background color
                                    onPrimary: _colorController.colorScheme
                                        .value.onSurface, // Header text color
                                    onSurface: _colorController
                                        .colorScheme
                                        .value
                                        .surface, // Text color in the dialog
                                  ),
                                  timePickerTheme: TimePickerThemeData(
                                    backgroundColor: _colorController
                                        .colorScheme
                                        .value
                                        .surface, // Background of the picker
                                    hourMinuteShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(
                                        color: _colorController
                                            .colorScheme.value.secondary,
                                        width: 2,
                                      ),
                                    ),
                                    hourMinuteTextStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _colorController.colorScheme.value
                                          .onSurface, // Text color for hours and minutes
                                    ),
                                    hourMinuteTextColor:
                                        WidgetStateColor.resolveWith(
                                            (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return _colorController
                                            .colorScheme
                                            .value
                                            .onSurface; // Selected segment text color
                                      }
                                      return _colorController
                                          .colorScheme.value.onSurface
                                          .withOpacity(
                                              0.8); // Unselected segment text color
                                    }),
                                    dialHandColor: _colorController.colorScheme
                                        .value.secondary, // Dial hand color
                                    dialBackgroundColor: _colorController
                                        .colorScheme
                                        .value
                                        .surface, // Dial background color
                                    dialTextColor: WidgetStateColor.resolveWith(
                                        (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return _colorController
                                            .colorScheme
                                            .value
                                            .onSurface; // Selected number color
                                      }
                                      return _colorController
                                          .colorScheme.value.onSurface
                                          .withOpacity(
                                              0.6); // Unselected numbers color
                                    }),
                                    dayPeriodColor:
                                        WidgetStateColor.resolveWith(
                                            (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return _colorController
                                            .colorScheme
                                            .value
                                            .primary; // Selected AM/PM background color
                                      }
                                      return _colorController.colorScheme.value
                                          .surface; // Unselected AM/PM background color
                                    }),
                                    dayPeriodTextColor:
                                        WidgetStateColor.resolveWith(
                                            (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return _colorController
                                            .colorScheme
                                            .value
                                            .onPrimary; // Selected AM/PM text color
                                      }
                                      return _colorController
                                          .colorScheme.value.onSurface
                                          .withOpacity(
                                              0.6); // Unselected AM/PM text color
                                    }),
                                  ),
                                ),
                                child: child!,
                              );
                            });

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                        'Update',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                _colorController.colorScheme.value.onSecondary),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        deletePopup();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
      updatedExpense.category = selectedCategory.value ?? expense!.category;
      updatedExpense.date = finalDateTime;
      updatedExpense.notes = notesController.text.trim();

      expenseController.updateExpense(updatedExpense, id);
    } else if (income != null) {
      Income updatedIncome = income!;
      updatedIncome.amount = double.parse(amountController.text.trim());
      updatedIncome.category = selectedCategory.value ?? income!.category;
      updatedIncome.date = finalDateTime;
      updatedIncome.notes = notesController.text.trim();

      incomeController.updateIncome(updatedIncome, id);
    }
  }

  void deletePopup() => Get.dialog(
        AlertDialog(
          title: Column(
            children: [
              Icon(Icons.delete_outline,
                  size: 50,
                  color: _colorController.colorScheme.value.secondary),
              const SizedBox(height: 10),
              Text(
                'Delete Note',
                style: TextStyle(
                  color: _colorController.colorScheme.value.secondary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Deleting a note will permanently remove it from your library.',
            style: TextStyle(
                fontSize: 16,
                color: _colorController.colorScheme.value.onSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Text(
                'No, Keep Note',
                style: TextStyle(
                    color: _colorController.colorScheme.value.onSecondary
                        .withOpacity(0.75)),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteTransaction(); // Call your delete method
                Get.back(); // Close the dialog
                Get.back(); // Go back after deleting
              },
              child: const Text(
                'Yes, Delete Note',
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ],
        ),
      );
  void _deleteTransaction() {
    if (expense != null) {
      expenseController.deleteExpense(
          expense!.userId, expense!.date.year, expense!.date.month, id);
    } else if (income != null) {
      incomeController.deleteIncome(
          income!.userId, income!.date.year, income!.date.month, id);
    }
  }
}
