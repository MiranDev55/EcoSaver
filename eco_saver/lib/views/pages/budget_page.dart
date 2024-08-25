import 'package:eco_saver/controllers/buttons_controller.dart';
import 'package:eco_saver/views/widgets/budget_widgets/budget_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/controllers/budget_controller.dart';
import 'package:eco_saver/utils/custom_container.dart';
import 'package:eco_saver/views/widgets/budget_widgets/budget_pie.dart';
import 'package:eco_saver/views/widgets/app_bar.dart';
import '../widgets/toggle_switch_button.dart';

class BudgetPage extends StatelessWidget {
  final ColorController colorController = Get.find<ColorController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final BudgetController budgetController = Get.find<BudgetController>();
  final ButtonsController buttonsController = Get.find<ButtonsController>();

  BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Budget",
      ),
      backgroundColor: colorController.colorScheme.value.surface,
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomContainer(
                  child: BudgetPie(
                    categoryController: categoryController,
                    colorController: colorController,
                  ),
                ),
                CustomContainer(
                  child: Column(
                    children: [
                      IntrinsicWidth(
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorController.colorScheme.value.primary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SelectableButton(
                                text: "Expense",
                                index: 0,
                                controller: buttonsController,
                                colorController: colorController,
                                pageSource: 0,
                              ),
                              SelectableButton(
                                text: "Income",
                                index: 1,
                                controller: buttonsController,
                                colorController: colorController,
                                pageSource: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      // List of categories with budget info
                      BudgetList(
                        categoryController: categoryController,
                        budgetController: budgetController,
                        colorController: colorController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
