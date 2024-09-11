import 'package:eco_saver/controllers/buttons_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/controllers/transaction_controller.dart';
import 'package:eco_saver/utils/custom_button.dart';
import 'package:eco_saver/utils/date_selector.dart';
import 'package:eco_saver/views/pages/transcription_pages/add_transcription.dart';
import 'package:eco_saver/views/widgets/appbar1.dart';
import 'package:eco_saver/utils/custom_container.dart';
import 'package:eco_saver/views/pages/transcription_pages/transactions_widgets/transcription_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionPage extends StatelessWidget {
  TransactionPage({super.key});

  final ColorController colorController = Get.find<ColorController>();
  final TransactionsController transactionsController =
      Get.find<TransactionsController>();
  final ButtonsController floatingButtonController =
      Get.find<ButtonsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Transcriptions"),
      backgroundColor: colorController.colorScheme.value.surface,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // TransactionDateSelector(
                //   initialDate: transactionsController.chosenDate,
                //   onMonthChanged: (selectedDate) {
                //     // Update both expenses and incomes for the selected month
                //     transactionsController.filterExpensesByMonth(selectedDate);
                //     transactionsController.filterIncomesByMonth(selectedDate);
                //   },
                //   colorController: colorController,
                // ),

                // Use the new CustomDateSelector
                CustomDateSelector(
                  initialDate: transactionsController.chosenDate,
                  onDateSelected: (selectedDate) {
                    // Update both expenses and incomes for the selected month
                    transactionsController.filterExpensesByMonth(selectedDate);
                    transactionsController.filterIncomesByMonth(selectedDate);
                  },
                  colorController: colorController, // Pass the color controller
                ),
                Expanded(
                  child: CustomContainer(
                      child:
                          TranscriptionList(colorController: colorController)),
                )
              ],
            ),
          ),
          _buildFloatingButtons(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          floatingButtonController.toggleTFB();
        },
        backgroundColor: colorController.colorScheme.value.secondary,
        child: Obx(() => Icon(
              floatingButtonController.isTFBExpanded.value
                  ? Icons.close
                  : Icons.add,
              color: colorController.colorScheme.value.onSecondary,
            )),
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Positioned(
      bottom: 80,
      right: 16,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (floatingButtonController.isTFBExpanded.value) ...[
              CustomButton(
                onPressed: () {
                  floatingButtonController.closeTFB();
                  Get.to(() => AddExpensePage(
                        isAddExpense: true,
                        title: 'Add Expense',
                      ));
                },
                text: 'Expense',
                icon: Icons.remove,
                alignment: Alignment.center,
                buttonStyle: CustomButtonStyle.defaultStyle(
                    colorController.colorScheme.value),
              ),
              const SizedBox(height: 10),
              CustomButton(
                onPressed: () {
                  floatingButtonController.closeTFB();
                  Get.to(() => AddExpensePage(
                        isAddExpense: false,
                        title: 'Add Income',
                      ));
                },
                text: 'Income',
                icon: Icons.add,
                alignment: Alignment.center,
                buttonStyle: CustomButtonStyle.defaultStyle(
                    colorController.colorScheme.value),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
