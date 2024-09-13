import 'package:eco_saver/controllers/budget_controller.dart';
import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/controllers/goal_controller.dart';
import 'package:eco_saver/controllers/total_balance_controller.dart';
import 'package:eco_saver/controllers/transaction_controller.dart';
import 'package:eco_saver/services/budget_service.dart';
import 'package:eco_saver/services/expenses_service.dart';
import 'package:eco_saver/services/goal_service.dart';
import 'package:eco_saver/services/incomes_service.dart';
import 'package:get/get.dart';

class LandingBinding extends Bindings {
  @override
  void dependencies() {
    // These controllers are dependent on the user's ID
    Get.put<ExpenseController>(ExpenseController());
    Get.put<IncomeController>(IncomeController());
    Get.put<TransactionsController>(TransactionsController());
    Get.put<CategoryController>(CategoryController());
    Get.put<TotalController>(TotalController());
    Get.put<BudgetService>(BudgetService());
    Get.put<BudgetController>(BudgetController());
    Get.put<GoalService>(GoalService());
    Get.put<GoalController>(GoalController());
  }
}
