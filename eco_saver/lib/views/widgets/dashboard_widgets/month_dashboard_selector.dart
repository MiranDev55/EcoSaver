import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eco_saver/controllers/total_balance_controller.dart';

class MonthDashboardSelector extends StatelessWidget {
  final TotalController _totalController = Get.find<TotalController>();

  MonthDashboardSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(() => DropdownButton<int>(
              value: _totalController.currentMonth.value,
              items: List.generate(12, (index) {
                return DropdownMenuItem(
                  value: index + 1,
                  child: Text(_monthName(index + 1)),
                );
              }),
              onChanged: (value) {
                if (value != null) {
                  _totalController.currentMonth.value = value;
                  _totalController.getTotalsForMonth(
                    _totalController.currentYear.value,
                    value,
                  );
                }
              },
            )),
        const SizedBox(width: 8),
        Obx(() => DropdownButton<int>(
              value: _totalController.currentYear.value,
              items: List.generate(10, (index) {
                int year = DateTime.now().year - index;
                return DropdownMenuItem(
                  value: year,
                  child: Text(year.toString()),
                );
              }),
              onChanged: (value) {
                if (value != null) {
                  _totalController.currentYear.value = value;
                  _totalController.getTotalsForMonth(
                    value,
                    _totalController.currentMonth.value,
                  );
                }
              },
            )),
      ],
    );
  }

  String _monthName(int month) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
