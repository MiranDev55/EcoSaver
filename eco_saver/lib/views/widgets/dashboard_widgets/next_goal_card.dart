import 'package:eco_saver/views/widgets/custom_card_pattern.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/color_controller.dart';

class NextGoalCard extends StatelessWidget {
  NextGoalCard({super.key});

  final ColorController _colorController = Get.find<ColorController>();

  @override
  Widget build(BuildContext context) {
    return CustomCardPattern(
      child: Column(
        children: [
          Text(
            'YOUR NEXT GOAL !',
            style: TextStyle(
              color: _colorController.colorScheme.value.onSecondary,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: _colorController.colorScheme.value.secondary),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Text(
              'First home',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _colorController.colorScheme.value
                    .onSecondary, // Text color based on selection
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            '\$3.190',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: _colorController.colorScheme.value.onSurface),
          ),
          const SizedBox(
            height: 8,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Routine saving: \$700',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Target: \$24000',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: double.infinity, // Takes all horizontal space
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _colorController.colorScheme.value.secondary,
                  foregroundColor:
                      _colorController.colorScheme.value.onSecondary),
              onPressed: () {
                // Button tap logic
              },
              child: const Text('Top up'),
            ),
          ),
        ],
      ),
    );
  }
}
