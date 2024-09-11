import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/controllers/goal_controller.dart';
import 'package:eco_saver/models/goals.dart';
import 'package:eco_saver/views/pages/goal_pages/goal_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalTile extends StatelessWidget {
  final Goal goal;
  final ColorController colorController;
  final GoalController goalController = Get.find<GoalController>();

  GoalTile({
    super.key,
    required this.goal,
    required this.colorController,
  });

  @override
  Widget build(BuildContext context) {
    double progressPercentage = goal.amountSaved / goal.targetAmount;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorController.colorScheme.value.secondary,
        child:
            Icon(Icons.home, color: colorController.colorScheme.value.primary),
      ),
      title: Text(
        goal.goalName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorController.colorScheme.value.onSurface,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: progressPercentage,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            minHeight: 10,
          ),
          const SizedBox(height: 5),
          Text(
            '${(progressPercentage * 100).toStringAsFixed(0)}% of \$${goal.targetAmount.toInt()}',
            style: TextStyle(
              color: colorController.colorScheme.value.onSurface,
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Navigate to the GoalDetails page with the goalId
        Get.to(() => GoalDetails(goalId: goal.id));
      },
    );
  }
}
