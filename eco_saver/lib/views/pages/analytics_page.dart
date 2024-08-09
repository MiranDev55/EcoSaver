// dashboard_page.dart
import 'package:eco_saver/controllers/buttons_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/views/widgets/analytics_chart.dart';
import 'package:eco_saver/views/widgets/app_bar.dart';
import 'package:eco_saver/views/widgets/custom_card_pattern.dart';
import 'package:eco_saver/views/widgets/toggle_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticsPage extends StatelessWidget {
  AnalyticsPage({super.key});

  final ColorController _colorController = Get.find<ColorController>();
  final ButtonsController buttonsController = Get.find<ButtonsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorController.colorScheme.value.surface,
      appBar: CustomAppBar(
        title: "Analytics",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: CustomCardPattern(
              child: Column(
                children: [
                  const SizedBox(height: 350, child: AnalyticsBarChart()),
                  IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _colorController.colorScheme.value
                            .primary, // Unselected background color
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SelectableButton(
                            text: "Popular",
                            index: 2,
                            controller: buttonsController,
                            colorController: _colorController,
                            pageSource: 1,
                          ),
                          SelectableButton(
                            text: "Alphabet",
                            index: 3,
                            controller: buttonsController,
                            colorController: _colorController,
                            pageSource: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //child: Container(),
            ),
          ),
        ),
      ),
    );
  }
}
