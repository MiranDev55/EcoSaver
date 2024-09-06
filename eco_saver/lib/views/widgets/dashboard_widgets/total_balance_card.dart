import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/controllers/total_balance_controller.dart';
import 'package:eco_saver/utils/custom_container.dart';
import 'package:eco_saver/utils/date_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToTalBalanceCard extends StatelessWidget {
  ToTalBalanceCard({super.key, required this.colorController});

  final ColorController colorController;
  final TotalController _totalController = Get.find<TotalController>();

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorController.colorScheme.value.onSurface,
                ),
              ),
              CustomDateSelector(
                initialDate: DateTime(_totalController.currentYear.value,
                    _totalController.currentMonth.value),
                colorController: colorController,
                onDateSelected: (selectedDate) {
                  // Update the TotalController with the selected month and year
                  _totalController.currentYear.value = selectedDate.year;
                  _totalController.currentMonth.value = selectedDate.month;
                  _totalController.getTotalsForMonth(
                      selectedDate.year, selectedDate.month);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              "\$${_totalController.totalBalance.value}",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: colorController.colorScheme.value.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Income',
                style: TextStyle(
                  fontSize: 18,
                  color: colorController.colorScheme.value.onSurface,
                ),
              ),
              Row(
                children: [
                  Obx(() => Text(
                        '\$${_totalController.currentMonthTotalIncome.value}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      )),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_upward,
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: colorController.colorScheme.value.onSurface.withOpacity(0.6),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Expenses',
                style: TextStyle(
                  fontSize: 18,
                  color: colorController.colorScheme.value.onSurface,
                ),
              ),
              Row(
                children: [
                  Obx(() => Text(
                        '\$${_totalController.currentMonthTotalExpense.value}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      )),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_downward,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
