import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/views/widgets/custom_card_pattern.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToTalBalanceCard extends StatelessWidget {
  ToTalBalanceCard({super.key});

  final ColorController colorController = Get.find<ColorController>();

  @override
  Widget build(BuildContext context) {
    return CustomCardPattern(
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
              Text(
                'January',
                style: TextStyle(
                  fontSize: 14,
                  color: colorController.colorScheme.value.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$1800',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: colorController.colorScheme.value.onSurface,
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
              const Row(
                children: [
                  Text(
                    '\$1500',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
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
                'Total Spent',
                style: TextStyle(
                  fontSize: 18,
                  color: colorController.colorScheme.value.onSurface,
                ),
              ),
              const Row(
                children: [
                  Text(
                    '\$1500',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
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
