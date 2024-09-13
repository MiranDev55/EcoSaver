import 'package:eco_saver/models/budget.dart';

import 'package:eco_saver/models/expense.dart';
import 'package:eco_saver/services/expenses_service.dart';
import 'package:get/get.dart';
import 'package:eco_saver/services/budget_service.dart';
import 'package:eco_saver/services/auth_service.dart';

class BudgetController extends GetxController {
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final BudgetService budgetService = Get.find<BudgetService>();
  final AuthService _authService = Get.find<AuthService>();

  // A map to hold the Budget objects for each category (e.g., "Groceries" -> Budget instance)
  RxMap<String, Budget> budgets = <String, Budget>{}.obs;

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
    _loadBudgets(_authService.userId!);
    ever(budgetService.categoryBudgets, (_) {
      _calculateSpendingForCurrentMonth();
      print("warning, this listener is going endless");
      //_loadBudgets(_authController.userId.value);
    });
  }

  // Method to create a budget for a specific category
  // Method to create a budget for a specific category
  Future<void> createBudget(String category, double amount) async {
    String userId = _authService.userId!;

    if (!budgets.containsKey(category)) {
      await budgetService.createBudget(userId, category, amount);

      // Load the created budget from the service and add to local budgets map
      Budget? newBudget = await budgetService.getBudget(userId, category);

      if (newBudget != null) {
        budgets[category] = newBudget; // Update local state with Budget model
      }
    }
  }

  // Load budgets from Firebase and update local budgets map
  Future<void> _loadBudgets(String userId) async {
    Map<String, Budget> loadedBudgets = {};

    // Fetch all budgets and map them as Budget models
    Map<String, double> rawBudgets = await budgetService.getAllBudgets(userId);

    rawBudgets.forEach((category, amount) {
      Budget? budget = budgetService.categoryBudgets[category];
      if (budget != null) {
        loadedBudgets[category] = budget;
      }
    });

    budgets.addAll(loadedBudgets); // Update local state
  }

// Method to update a budget for a specific category
  Future<void> updateBudget(String category, double amount) async {
    String userId = _authService.userId!;

    if (budgets.containsKey(category)) {
      await budgetService.updateBudget(userId, category, amount);

      // Create a new Budget object with the updated budget and dateModified, keeping other fields the same
      Budget updatedBudget = Budget(
        name: budgets[category]!.name,
        budget: amount, // Update the budget amount
        dateCreated:
            budgets[category]!.dateCreated, // Keep the original creation date
        dateModified: DateTime.now(), // Update the modification date
      );

      // Update the local state with the new Budget object
      budgets[category] = updatedBudget;
    }
  }

  // Method to delete a budget for a specific category
  Future<void> deleteBudget(String category) async {
    String userId = _authService.userId!;
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
    double budget = budgets[category]?.budget ?? 0.0;
    double spentAmount = spent[category] ?? 0.0;
    return budget - spentAmount;
  }

  // Method to update the touched index in the pie chart
  void updatePieChartTouchedIndex(int index) {
    pieChartTouchedIndex.value = index;
  }
}
