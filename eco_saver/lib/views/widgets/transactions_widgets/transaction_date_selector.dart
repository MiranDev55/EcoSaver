import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For formatting date

class TransactionDateSelector extends StatelessWidget {
  final Function(DateTime) onMonthChanged;
  final DateTime initialDate;

  TransactionDateSelector(
      {super.key, required this.onMonthChanged, required this.initialDate});

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  Widget build(BuildContext context) {
    selectedDate.value = initialDate;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            selectedDate.value = DateTime(selectedDate.value.year,
                selectedDate.value.month - 1, selectedDate.value.day);
            onMonthChanged(selectedDate.value);
          },
        ),
        Obx(() => Text(
            DateFormat.yMMMM()
                .format(selectedDate.value), // Display month and year
            style: Theme.of(context).textTheme.titleMedium)),
        IconButton(
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
}
