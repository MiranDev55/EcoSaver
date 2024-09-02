import 'package:eco_saver/models/expense.dart';
import 'package:eco_saver/services/expenses_service.dart';
import 'package:get/get.dart';
import 'package:eco_saver/services/budget_service.dart';
import 'package:eco_saver/services/auth_service.dart';

class BudgetController extends GetxController {
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final BudgetService budgetService = Get.find<BudgetService>();
  final AuthService authController = Get.find<AuthService>();

  // A map to hold the budget for each category (e.g., "Groceries" -> 200.0)
  RxMap<String, double> budgets = <String, double>{}.obs;

  // A map to hold the amount spent in each category (e.g., "Groceries" -> 50.0)
  RxMap<String, double> spent = <String, double>{}.obs;

  // Holds the index of the currently touched section in the pie chart
  RxInt pieChartTouchedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();

    // Recalculate spending whenever the expenses change
    ever(expenseController.monthlyExpense, (_) {
      _calculateSpendingForCurrentMonth();
    });

    ever(budgetService.categoryBudgets, (_) {
      _calculateSpendingForCurrentMonth();
    });

    // Listen to user ID changes to load the corresponding budgets
    ever(authController.userId, (String userId) {
      if (userId.isNotEmpty) {
        _loadBudgets(userId);
      } else {
        budgets.clear();
        spent.clear();
      }
    });
  }

  // Method to create a budget for a specific category
  Future<void> createBudget(String category, double amount) async {
    String userId = authController.userId.value;

    if (!budgets.containsKey(category)) {
      await budgetService.createBudget(userId, category, amount);
      budgets[category] = amount; // Update local state
    }
  }

  // Load budgets from Firebase
  Future<void> _loadBudgets(String userId) async {
    Map<String, double> loadedBudgets =
        await budgetService.getAllBudgets(userId);
    budgets.addAll(loadedBudgets);
  }

  // Method to update a budget for a specific category
  Future<void> updateBudget(String category, double amount) async {
    String userId = authController.userId.value;

    if (budgets.containsKey(category)) {
      await budgetService.updateBudget(userId, category, amount);
      budgets[category] = amount; // Update local state
    }
  }

  // Method to delete a budget for a specific category
  Future<void> deleteBudget(String category) async {
    String userId = authController.userId.value;
    if (budgets.containsKey(category)) {
      await budgetService.deleteBudget(userId, category);
      budgets.remove(category); // Update local state
      spent.remove(category); // Optionally remove spent data
    }
  }

  // Calculate the spending for the current month
  void _calculateSpendingForCurrentMonth() {
    spent.clear();
    expenseController.monthlyExpense.forEach((_, docMap) {
      docMap.forEach((docId, expenses) {
        for (Expense expense in expenses) {
          updateSpending(expense.category, expense.amount);
        }
      });
    });
  }

  // Method to update spending for a specific category
  void updateSpending(String category, double amount) {
    if (spent.containsKey(category)) {
      spent[category] = spent[category]! + amount;
    } else {
      spent[category] = amount;
    }
  }

  // Method to get the remaining budget for a category
  double remainingBudget(String category) {
    double budget = budgets[category] ?? 0.0;
    double spentAmount = spent[category] ?? 0.0;
    return budget - spentAmount;
  }

  // Method to update the touched index
  void updatePieChartTouchedIndex(int index) {
    pieChartTouchedIndex.value = index;
  }
}
