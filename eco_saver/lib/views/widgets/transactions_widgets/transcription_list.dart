import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/controllers/transaction_controller.dart';
import 'package:eco_saver/models/expense.dart';
import 'package:eco_saver/models/income.dart';
import 'package:eco_saver/views/pages/transcription_pages/edit_transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TranscriptionList extends StatelessWidget {
  final ColorController colorController;
  final CategoryController _categoryController = Get.find<CategoryController>();

  TranscriptionList({super.key, required this.colorController});

  final TransactionsController transactionsController =
      Get.find<TransactionsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Map<String, dynamic>> transactions =
          transactionsController.getCombinedSortedTransactions();

      return ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: colorController.colorScheme.value.onPrimaryContainer,
        ),
        shrinkWrap: true,
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transactionMap = transactions[index];
          final transaction = transactionMap['transaction'];
          final docId = transactionMap['id'];
          final isExpense = transaction is Expense;

          return GestureDetector(
            onTap: () {
              Get.to(() => EditTransactionPage(
                    expense: isExpense ? transaction : null,
                    income: isExpense ? null : transaction as Income,
                    title: isExpense ? 'Edit Expense' : 'Edit Income',
                    id: docId, // Pass the document ID to the edit page
                  ));
            },
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              color: colorController.colorScheme.value.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getIconForCategory(transaction.category),
                          color: colorController.colorScheme.value.primary,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.category,
                              style: TextStyle(
                                color:
                                    colorController.colorScheme.value.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              DateFormat('MMM dd, hh:mm a')
                                  .format(transaction.date),
                              style: TextStyle(
                                color:
                                    colorController.colorScheme.value.primary,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '${isExpense ? "-" : "+"}\$${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isExpense ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  IconData _getIconForCategory(String categoryName) {
    final expenseCategory = _categoryController.expenseCategories
        .firstWhereOrNull((cat) => cat.name == categoryName);
    final incomeCategory = _categoryController.incomeCategories
        .firstWhereOrNull((cat) => cat.name == categoryName);

    return expenseCategory?.icon ?? incomeCategory?.icon ?? Icons.help_outline;
  }
}
