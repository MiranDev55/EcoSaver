import 'package:eco_saver/controllers/buttons_controller.dart';
import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/views/widgets/app_bar.dart';
import 'package:eco_saver/views/widgets/custom_card_pattern.dart';
import 'package:eco_saver/views/widgets/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/toggle_switch_button.dart'; // Ensure you have the correct path

class CategoriesPage extends StatelessWidget {
  final ColorController _colorController = Get.find<ColorController>();
  final CategoryController categoryController =
      Get.put(CategoryController(), permanent: true);

  final ButtonsController buttonsController = Get.find<ButtonsController>();

  CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Categories",
      ),
      backgroundColor: _colorController.colorScheme.value.surface,
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomCardPattern(
                  child: CategoryPieChart(
                      categoryController: categoryController,
                      colorController: _colorController),
                ),
                CustomCardPattern(
                    child: Column(
                  children: [
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
                              index: 0,
                              controller: buttonsController,
                              colorController: _colorController,
                              pageSource: 0,
                            ),
                            SelectableButton(
                              text: "Alphabet",
                              index: 1,
                              controller: buttonsController,
                              colorController: _colorController,
                              pageSource: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // List of categories
                    ListView.separated(
                      shrinkWrap:
                          true, // Allows the ListView to be placed inside a Column
                      physics:
                          const NeverScrollableScrollPhysics(), // Prevents scrolling in the nested ListView
                      itemCount: categoryController.categories.length,
                      itemBuilder: (context, index) {
                        final category = categoryController.categories[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: category.color,
                            radius: 5,
                          ),
                          title: Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          height: 3,
                          endIndent: 20,
                          indent: 20,
                        );
                      },
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
