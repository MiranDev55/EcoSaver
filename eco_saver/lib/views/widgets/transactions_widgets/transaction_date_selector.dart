import 'package:eco_saver/controllers/color_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For formatting date

class TransactionDateSelector extends StatelessWidget {
  final Function(DateTime) onMonthChanged;
  final DateTime initialDate;
  final ColorController colorController;

  TransactionDateSelector(
      {super.key,
      required this.onMonthChanged,
      required this.initialDate,
      required this.colorController});

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  Widget build(BuildContext context) {
    selectedDate.value = initialDate;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          color: colorController.colorScheme.value.primary,
          icon: const Icon(
            Icons.chevron_left,
          ),
          onPressed: () {
            selectedDate.value = DateTime(selectedDate.value.year,
                selectedDate.value.month - 1, selectedDate.value.day);
            onMonthChanged(selectedDate.value);
          },
        ),
        Obx(() => InkWell(
              onTap: () {
                _showMonthYearPickerDialog(context);
              },
              child: Text(
                DateFormat.yMMMM()
                    .format(selectedDate.value), // Display month and year
                style: TextStyle(
                    color: colorController.colorScheme.value.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            )),
        IconButton(
          color: colorController.colorScheme.value.primary,
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            selectedDate.value = DateTime(selectedDate.value.year,
                selectedDate.value.month + 1, selectedDate.value.day);
            onMonthChanged(selectedDate.value);
          },
        ),
      ],
    );
  }

  void _showMonthYearPickerDialog(BuildContext context) {
    DateTime selectedDateLocal = selectedDate.value;
    int selectedYear = selectedDateLocal.year;
    int selectedMonth = selectedDateLocal.month;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Month and Year'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Year Dropdown
              Expanded(
                child: DropdownButton<int>(
                  value: selectedYear,
                  items: List.generate(100, (index) {
                    int year = DateTime.now().year - 50 + index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text('$year'),
                    );
                  }),
                  onChanged: (newYear) {
                    selectedYear = newYear!;
                  },
                ),
              ),
              // Month Dropdown
              Expanded(
                child: DropdownButton<int>(
                  value: selectedMonth,
                  items: List.generate(12, (index) {
                    int month = index + 1;
                    return DropdownMenuItem(
                      value: month,
                      child: Text(DateFormat.MMMM().format(DateTime(0, month))),
                    );
                  }),
                  onChanged: (newMonth) {
                    selectedMonth = newMonth!;
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                selectedDate.value = DateTime(selectedYear, selectedMonth);
                onMonthChanged(selectedDate.value);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
