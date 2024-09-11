import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:eco_saver/controllers/color_controller.dart';

class BudgetPieChart extends StatelessWidget {
  final double spent;
  final double budget;
  final ColorController colorController;

  // List to hold random light colors for the pie chart
  final List<Color> _randomColors = [];

  BudgetPieChart({
    super.key,
    required this.spent,
    required this.budget,
    required this.colorController,
  }) {
    // Generate random colors for the pie chart (two colors: for spent and remaining)
    _generateRandomColors();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: _randomColors[0],
              value: spent,
              title: 'Spent\n\$${spent.toStringAsFixed(2)}',
              radius: 60,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorController.colorScheme.value.onSecondary,
              ),
            ),
            PieChartSectionData(
              color: _randomColors[1],
              value: budget - spent,
              title: 'Remaining\n\$${(budget - spent).toStringAsFixed(2)}',
              radius: 60,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorController.colorScheme.value.onSecondary,
              ),
            ),
          ],
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  // Function to generate random colors for the pie chart
  void _generateRandomColors() {
    final random = Random();
    _randomColors.add(Color.fromRGBO(
        175 + random.nextInt(81),
        175 + random.nextInt(81),
        175 + random.nextInt(81),
        1.0)); // Color for 'Spent'
    _randomColors.add(Color.fromRGBO(
        175 + random.nextInt(81),
        175 + random.nextInt(81),
        175 + random.nextInt(81),
        1.0)); // Color for 'Remaining'
  }
}
