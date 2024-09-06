import 'package:eco_saver/controllers/color_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For formatting date

class CustomDateSelector extends StatelessWidget {
  final Function(DateTime)
      onDateSelected; // Callback to return the selected date
  final DateTime initialDate;
  final ColorController colorController;

  CustomDateSelector({
    super.key,
    required this.onDateSelected,
    required this.initialDate,
    required this.colorController,
  });

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  Widget build(BuildContext context) {
    selectedDate.value = initialDate;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          color: colorController.colorScheme.value.primary,
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            selectedDate.value = DateTime(selectedDate.value.year,
                selectedDate.value.month - 1, selectedDate.value.day);
            onDateSelected(
                selectedDate.value); // Return the updated date to the caller
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
                  fontSize: 16,
                ),
              ),
            )),
        IconButton(
          color: colorController.colorScheme.value.primary,
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            selectedDate.value = DateTime(selectedDate.value.year,
                selectedDate.value.month + 1, selectedDate.value.day);
            onDateSelected(
                selectedDate.value); // Return the updated date to the caller
          },
        ),
      ],
    );
  }

  void _showMonthYearPickerDialog(BuildContext context) {
    // Use RxInt for real-time updates of year and month in the dialog
    RxInt selectedYear = selectedDate.value.year.obs;
    RxInt selectedMonth = selectedDate.value.month.obs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Month and Year',
            style: TextStyle(color: colorController.colorScheme.value.primary),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Year Dropdown
              Expanded(
                child: Obx(() => DropdownButton<int>(
                      value: selectedYear.value,
                      dropdownColor: colorController.colorScheme.value
                          .surface, // Sets the dropdown background color
                      style: TextStyle(
                        color: colorController.colorScheme.value
                            .primary, // Sets the color of the selected value text
                      ),
                      items: List.generate(100, (index) {
                        int year = DateTime.now().year - 50 + index;
                        return DropdownMenuItem(
                          value: year,
                          child: Text(
                            '$year',
                            style: TextStyle(
                                color:
                                    colorController.colorScheme.value.primary),
                          ),
                        );
                      }),
                      onChanged: (newYear) {
                        selectedYear.value = newYear!;
                      },
                    )),
              ),
              // Month Dropdown
              Expanded(
                child: Obx(() => DropdownButton<int>(
                      value: selectedMonth.value,
                      dropdownColor: colorController.colorScheme.value
                          .surface, // Sets the dropdown background color
                      style: TextStyle(
                        color: colorController.colorScheme.value
                            .primary, // Sets the color of the selected value text
                      ),
                      items: List.generate(12, (index) {
                        int month = index + 1;
                        return DropdownMenuItem(
                          value: month,
                          child: Text(
                            DateFormat.MMMM().format(DateTime(0, month)),
                            style: TextStyle(
                                color:
                                    colorController.colorScheme.value.primary),
                          ),
                        );
                      }),
                      onChanged: (newMonth) {
                        selectedMonth.value = newMonth!;
                      },
                    )),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.pink),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'OK',
                style:
                    TextStyle(color: colorController.colorScheme.value.primary),
              ),
              onPressed: () {
                selectedDate.value =
                    DateTime(selectedYear.value, selectedMonth.value);
                onDateSelected(selectedDate.value); // Return the selected date
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
