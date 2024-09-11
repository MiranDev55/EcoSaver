import 'package:eco_saver/controllers/budget_controller.dart';
import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/controllers/goal_controller.dart';
import 'package:eco_saver/controllers/total_balance_controller.dart';
import 'package:eco_saver/controllers/transaction_controller.dart';
import 'package:eco_saver/services/auth_service.dart';
import 'package:eco_saver/services/budget_service.dart';
import 'package:eco_saver/services/expenses_service.dart';
import 'package:eco_saver/services/goal_service.dart';
import 'package:eco_saver/services/incomes_service.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    final AuthService authService = Get.find<AuthService>();

    // Initialize user-dependent controllers only if the user is logged in
    if (authService.isLoggedIn()) {
      _initializeUserDependentControllers();
    }
  }

  void _initializeUserDependentControllers() {
    Get.lazyPut(() => ExpenseController());
    Get.lazyPut(() => IncomeController());
    Get.lazyPut(() => TransactionsController());
    Get.lazyPut(() => CategoryController());
    Get.lazyPut(() => TotalController());
    Get.lazyPut(() => BudgetService());
    Get.lazyPut(() => BudgetController());
    Get.lazyPut(() => GoalService());
    Get.lazyPut(() => GoalController());
  }
}
