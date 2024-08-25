import 'package:eco_saver/models/expense.dart';
import 'package:eco_saver/models/income.dart';
import 'package:eco_saver/services/expenses_service.dart';
import 'package:eco_saver/services/incomes_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TransactionsController extends GetxController {
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final IncomeController incomeController = Get.find<IncomeController>();

  RxList<dynamic> transactions = RxList<dynamic>();

  bool isInitExpense = true;
  bool isInitIncome = true;

  @override
  void onInit() {
    super.onInit();

    ever(expenseController.monthlyExpense,
        (Map<String, List<Expense>> expense) {
      // Automatically update transactions when monthlyExpense cache changes.
      if (isInitExpense) {
        isInitExpense = false;
        _updateTransactionsForCurrentMonth();
      }
    });

    ever(incomeController.monthlyIncome, (Map<String, List<Income>> income) {
      // Automatically update transactions when monthlyIncome cache changes.

      if (isInitIncome) {
        isInitIncome = false;
        _updateTransactionsForCurrentMonth();
      }
    });
  }

  void _updateTransactionsForCurrentMonth() {
    // Assuming a method or a variable to get the currently selected date.
    DateTime selectedDate =
        DateTime.now(); // Replace with actual selected date logic.
    filterTransactionsByMonth(selectedDate);
  }

  void filterTransactionsByMonth(DateTime selectedDate) {
    String? dateKey = '${selectedDate.year}-${selectedDate.month}';
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Clear the transactions list
    transactions.clear();

    List<dynamic> combined = [];

    // Check if expenses for the selected month are cached and add them
    if (expenseController.monthlyExpense.containsKey(dateKey)) {
      combined.addAll(expenseController.monthlyExpense[dateKey]!);
    } else {
      expenseController.getUserExpensesForMonth(
          uid, selectedDate.year, selectedDate.month);
    }

    // Check if incomes for the selected month are cached and add them
    if (incomeController.monthlyIncome.containsKey(dateKey)) {
      combined.addAll(incomeController.monthlyIncome[dateKey]!);
    } else {
      incomeController.getUserIncomesForMonth(
          uid, selectedDate.year, selectedDate.month);
    }

    // Sort by date if needed
    combined.sort((a, b) => b.date.compareTo(a.date));

    // Update transactions list with the combined data
    transactions.addAll(combined);
  }
}
