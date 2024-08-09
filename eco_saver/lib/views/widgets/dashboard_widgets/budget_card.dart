import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/views/widgets/custom_card_pattern.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BudgetCard extends StatelessWidget {
  BudgetCard({super.key});
  final ColorController _colorController = Get.find<ColorController>();

  final double budgetUsed = 30.00;
  final double budgetTotal = 200.00;

  @override
  Widget build(BuildContext context) {
    return CustomCardPattern(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Food budget',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: budgetUsed / budgetTotal,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
                _colorController.colorScheme.value.secondary),
            minHeight: 20.0,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${budgetUsed.toStringAsFixed(2)} of \$${budgetTotal.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 16.0,
                    color: _colorController.colorScheme.value.onSurface),
              ),
              Text(
                '${(budgetUsed / budgetTotal * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 16.0, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
