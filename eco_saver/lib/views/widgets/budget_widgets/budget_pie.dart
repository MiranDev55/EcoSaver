import 'dart:math';
import 'package:eco_saver/controllers/budget_controller.dart';
import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/views/widgets/budget_widgets/pie_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/color_controller.dart';

class BudgetPie extends StatelessWidget {
  final CategoryController categoryController;
  final ColorController colorController;
  final BudgetController budgetController = Get.find<BudgetController>();

  // List to hold random light colors for each category
  final List<Color> _randomColors = [];

  BudgetPie(
      {super.key,
      required this.categoryController,
      required this.colorController}) {
    // Generate random light colors for each category
    _generateRandomColors();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final totalBudget =
          budgetController.budgets.values.fold(0.0, (sum, item) => sum + item);

      return AspectRatio(
        aspectRatio: 1.3,
        child: Column(
          children: <Widget>[
            Text(
              'Total Budget: \$${totalBudget.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorController.colorScheme.value.onSecondary,
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                budgetController.updatePieChartTouchedIndex(-1);
                                return;
                              }
                              budgetController.updatePieChartTouchedIndex(
                                  pieTouchResponse
                                      .touchedSection!.touchedSectionIndex);
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: budgetController.budgets.keys.map((category) {
                      final colorIndex = budgetController.budgets.keys
                          .toList()
                          .indexOf(category);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Indicator(
                          color: _randomColors.isNotEmpty &&
                                  colorIndex < _randomColors.length
                              ? _randomColors[colorIndex]
                              : Colors.grey, // Fallback color
                          text: category,
                          isSquare: true,
                          textColor:
                              colorController.colorScheme.value.onSecondary,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  List<PieChartSectionData> showingSections() {
    final totalBudget =
        budgetController.budgets.values.fold(0.0, (sum, item) => sum + item);

    return budgetController.budgets.keys.map((category) {
      final categoryBudget = budgetController.budgets[category] ?? 0.0;
      final percentage =
          totalBudget == 0 ? 0.0 : (categoryBudget / totalBudget) * 100;

      final isTouched = budgetController.pieChartTouchedIndex.value ==
          budgetController.budgets.keys.toList().indexOf(category);
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      final colorIndex =
          budgetController.budgets.keys.toList().indexOf(category);

      return PieChartSectionData(
        color: _randomColors.isNotEmpty && colorIndex < _randomColors.length
            ? _randomColors[colorIndex]
            : Colors.grey, // Fallback color
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: colorController.colorScheme.value.onSecondary,
        ),
      );
    }).toList();
  }

  void _generateRandomColors() {
    final random = Random();

    for (int i = 0; i < budgetController.budgets.keys.length; i++) {
      _randomColors.add(
        Color.fromRGBO(
          175 + random.nextInt(81), // Values between 175-255 for R
          175 + random.nextInt(81), // Values between 175-255 for G
          175 + random.nextInt(81), // Values between 175-255 for B
          1.0, // Fully opaque
        ),
      );
    }
  }
}
