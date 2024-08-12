// dashboard_page.dart
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/views/pages/add_expense.dart';
import 'package:eco_saver/views/widgets/app_bar.dart';
import 'package:eco_saver/views/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionPage extends StatelessWidget {
  TransactionPage({super.key});

  final ColorController colorController = Get.find<ColorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Transcriptions"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => AddExpensePage());
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(colorController
                      .colorScheme.value.secondary), // Set button color
                  foregroundColor: WidgetStateProperty.all(colorController
                      .colorScheme
                      .value
                      .onSecondary), // Set text and icon color
                  elevation: WidgetStateProperty.all(
                      2), // Control shadow beneath the button
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ), // Padding inside the button
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30.0), // Rounded corners
                    ),
                  ),
                ),
                child: const Wrap(
                  // Wrap widget added here
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing:
                      8.0, // Optional: to add space between the Text and Icon
                  children: [
                    Text("ADD"),
                    Icon(Icons.add),
                  ],
                ),
              ),
            ),
            Expanded(child: ExpenseList(colorController: colorController)),
          ],
        ),
      ),
    );
  }
}
