import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/controllers/transaction_controller.dart';
import 'package:eco_saver/models/expense.dart';
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
      List<dynamic> transactions = transactionsController.transactions;

      return ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: colorController.colorScheme.value.onPrimaryContainer,
        ),
        shrinkWrap: true,
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final isExpense = transaction is Expense;

          return Container(
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
                              color: colorController.colorScheme.value.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            DateFormat('MMM dd, hh:mm a')
                                .format(transaction.date),
                            style: TextStyle(
                              color: colorController.colorScheme.value.primary,
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
