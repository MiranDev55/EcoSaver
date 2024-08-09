import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/models/goals.dart';
import 'package:flutter/material.dart';

class GoalTile extends StatelessWidget {
  final Goal goal;
  final ColorController colorController;

  const GoalTile(
      {super.key, required this.goal, required this.colorController});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.orange,
        child: Icon(Icons.home, color: Colors.white),
      ),
      title: Text(
        goal.title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorController.colorScheme.value.onSurface),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: goal.progressPercentage,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            minHeight: 10,
          ),
          const SizedBox(height: 5),
          Text(
            '${(goal.progressPercentage * 100).toInt()}% of \$${goal.goalAmount.toInt()}',
            style:
                TextStyle(color: colorController.colorScheme.value.onSurface),
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Define the action when the ListTile is tapped
      },
    );
  }
}
