import 'package:eco_saver/controllers/category_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/color_controller.dart';

class BudgetPie extends StatelessWidget {
  final CategoryController categoryController;
  final ColorController colorController;
  const BudgetPie(
      {super.key,
      required this.categoryController,
      required this.colorController});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Obx(() {
                return PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          categoryController.updatePieChartTouchedIndex(-1);
                          return;
                        }
                        categoryController.updatePieChartTouchedIndex(
                            pieTouchResponse
                                .touchedSection!.touchedSectionIndex);
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(
                        categoryController.pieChartTouchedIndex.value),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(int touchedIndex) {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.amber,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: colorController.colorScheme.value.onPrimary,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.indigo,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: colorController.colorScheme.value.onPrimary,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: colorController.colorScheme.value.onPrimary,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.lime,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: colorController.colorScheme.value.onPrimary,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
