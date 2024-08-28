import 'package:eco_saver/models/expense.dart';
import 'package:eco_saver/models/income.dart';
import 'package:eco_saver/services/expenses_service.dart';
import 'package:eco_saver/services/incomes_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TransactionsController extends GetxController {
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final IncomeController incomeController = Get.find<IncomeController>();

  RxMap<String, Expense> expenses =
      RxMap<String, Expense>(); // Store with doc ID
  RxMap<String, Income> incomes = RxMap<String, Income>(); // Store with doc ID

  DateTime chosenDate = DateTime.now();

  @override
  void onInit() {
    super.onInit();

    ever(expenseController.monthlyExpense,
        (Map<String, Map<String, List<Expense>>> expenseMap) {
      filterExpensesByMonth(chosenDate);
      //_updateExpensesForCurrentMonth();
    });

    ever(incomeController.monthlyIncome,
        (Map<String, Map<String, List<Income>>> incomeMap) {
      filterIncomesByMonth(chosenDate);
      //_updateIncomesForCurrentMonth();
    });
  }

  void filterExpensesByMonth(DateTime selectedDate) {
    chosenDate = selectedDate;
    String dateKey = '${selectedDate.year}-${selectedDate.month}';

    if (expenseController.monthlyExpense.containsKey(dateKey)) {
      expenses.clear();
      expenseController.monthlyExpense[dateKey]!.forEach((docId, expenseList) {
        for (var expense in expenseList) {
          expenses[docId] = expense; // Store each expense with its doc ID
        }
      });
    } else {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      expenseController.getUserExpensesForMonth(
          uid, selectedDate.year, selectedDate.month);
    }
  }

  void filterIncomesByMonth(DateTime selectedDate) {
    String dateKey = '${selectedDate.year}-${selectedDate.month}';
    incomes.clear();

    if (incomeController.monthlyIncome.containsKey(dateKey)) {
      incomeController.monthlyIncome[dateKey]!.forEach((docId, incomeList) {
        for (var income in incomeList) {
          incomes[docId] = income; // Store each income with its doc ID
        }
      });
    } else {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      incomeController.getUserIncomesForMonth(
          uid, selectedDate.year, selectedDate.month);
    }
  }

  // Method to get a combined and sorted list of transactions with their document IDs
  List<Map<String, dynamic>> getCombinedSortedTransactions() {
    List<Map<String, dynamic>> combined = [];

    // Add all expenses with their doc IDs
    expenses.forEach((docId, expense) {
      combined.add({'id': docId, 'transaction': expense});
    });

    // Add all incomes with their doc IDs
    incomes.forEach((docId, income) {
      combined.add({'id': docId, 'transaction': income});
    });

    // Sort combined list by date
    combined
        .sort((a, b) => b['transaction'].date.compareTo(a['transaction'].date));

    return combined;
  }
}
