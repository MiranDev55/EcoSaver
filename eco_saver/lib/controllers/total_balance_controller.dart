import 'package:eco_saver/models/expense.dart';
import 'package:eco_saver/models/income.dart';
import 'package:eco_saver/services/expenses_service.dart';
import 'package:eco_saver/services/incomes_service.dart';
import 'package:get/get.dart';
import 'package:eco_saver/controllers/auth_controller.dart';

class TotalController extends GetxController {
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final IncomeController incomeController = Get.find<IncomeController>();
  final AuthController authController = Get.find<AuthController>();

  RxDouble currentMonthTotalExpense = 0.0.obs;
  RxDouble currentMonthTotalIncome = 0.0.obs;
  RxDouble totalBalance = 0.0.obs;

  RxInt currentMonth = DateTime.now().month.obs;
  RxInt currentYear = DateTime.now().year.obs;

  @override
  void onInit() {
    super.onInit();

    // Watch for changes in the expense and income for the currently viewed month
    ever(expenseController.monthlyExpense, (_) {
      String viewedMonthKey = '${currentYear.value}-${currentMonth.value}';
      if (expenseController.monthlyExpense.containsKey(viewedMonthKey)) {
        calculateTotalsForMonth(currentYear.value, currentMonth.value);
      }
    });

    ever(incomeController.monthlyIncome, (_) {
      String viewedMonthKey = '${currentYear.value}-${currentMonth.value}';
      if (incomeController.monthlyIncome.containsKey(viewedMonthKey)) {
        calculateTotalsForMonth(currentYear.value, currentMonth.value);
      }
    });

    // Listen for changes in the viewed month and year
    everAll([currentYear, currentMonth], (_) {
      String userId = authController.userId.value;
      if (userId.isNotEmpty) {
        calculateTotalsForMonth(currentYear.value, currentMonth.value);
      }
    });
  }

  // Method to calculate totals for a specified year and month
  Future<void> calculateTotalsForMonth(int year, int month) async {
    // Get the expenses and incomes from the cache
    String dateKey = '$year-$month';

    List<Expense> monthExpenses = [];
    List<Income> monthIncomes = [];

    if (expenseController.monthlyExpense.containsKey(dateKey)) {
      //monthExpenses = expenseController.monthlyExpense[dateKey]!;
    } else {
      expenseController.getUserExpensesForMonth(
          authController.userId.value, year, month);
      return;
    }

    if (incomeController.monthlyIncome.containsKey(dateKey)) {
      monthIncomes = incomeController.monthlyIncome[dateKey]!;
    } else {
      incomeController.getUserIncomesForMonth(
          authController.userId.value, year, month);
      return;
    }
    // List<Expense> monthExpenses =
    //     expenseController.monthlyExpense[dateKey] ?? [];
    // List<Income> monthIncomes = incomeController.monthlyIncome[dateKey] ?? [];

    // Calculate the totals
    double totalExpense =
        monthExpenses.fold(0.0, (sum, item) => sum + item.amount);
    double totalIncome =
        monthIncomes.fold(0.0, (sum, item) => sum + item.amount);

    // Store the totals for the currently viewed month
    currentMonthTotalExpense.value = totalExpense;
    currentMonthTotalIncome.value = totalIncome;

    totalBalance.value = totalIncome - totalExpense;
  }

  // Method to get the total of any other specified month
  Future<void> getTotalsForMonth(int year, int month) async {
    currentYear.value = year;
    currentMonth.value = month;

    await calculateTotalsForMonth(year, month);
  }
}
