import 'package:eco_saver/controllers/auth_controller.dart';
import 'package:eco_saver/models/expense.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthController authController = Get.find<AuthController>();

  RxMap<String, List<Expense>> monthlyExpense =
      RxMap<String, List<Expense>>(); // Cache to store expenses by month

  @override
  void onInit() {
    super.onInit();

    // Watch for changes in the user ID and fetch expenses when it changes
    ever(authController.userId, (String userId) {
      if (userId.isNotEmpty) {
        getUserExpensesForCurrentMonth(userId);
      } else {
        // Clear the expenses if the user is not logged in
        monthlyExpense.clear();
      }
    });
  }

  // Method to retrieve expenses for the current month
  Future<void> getUserExpensesForCurrentMonth(String userId) async {
    DateTime now = DateTime.now();
    await getUserExpensesForMonth(userId, now.year, now.month);
  }

  Future<List<Map<String, Expense>>> getUserExpensesForMonth(
      String userId, int year, int month) async {
    String cacheKey = '$year-$month';

    if (monthlyExpense.containsKey(cacheKey)) {
      // Transform cached data into a list of map with id and model instance
      return monthlyExpense[cacheKey]!
          .map((expense) => {expense.createdAt.toString(): expense})
          .toList();
    }

    try {
      final snapshot = await _db
          .collection('expenses')
          .doc(userId)
          .collection('$year')
          .doc('$month')
          .collection('user expenses')
          .get();

      List<Map<String, Expense>> monthExpenses = snapshot.docs.map((doc) {
        final expense = Expense.fromJson(doc.data());
        return {
          doc.id: expense
        }; // Return a map with the document ID as the key
      }).toList();

      // Cache the expenses for this month
      monthlyExpense[cacheKey] =
          monthExpenses.map((map) => map.values.first).toList();

      return monthExpenses;
    } catch (e) {
      // ignore: avoid_print
      print('Error retrieving expenses: $e');
      return [];
    }
  }

  // Create an expense for a specific user in a specific year and month
  Future<void> createExpense(Expense expense) async {
    try {
      String dateKey = '${expense.date.year}-${expense.date.month}';

      // Add the expense to Firestore
      await _db
          .collection('expenses')
          .doc(expense.userId)
          .collection('${expense.date.year}')
          .doc('${expense.date.month}')
          .collection('user expenses')
          .doc() // Firestore generates a unique ID for each expense
          .set(expense.toJson());

      // If the Firestore operation is successful, update the cache
      if (monthlyExpense.containsKey(dateKey)) {
        final updatedList = List<Expense>.from(monthlyExpense[dateKey]!);
        updatedList.add(expense);
        monthlyExpense[dateKey] = updatedList; // Reassign to trigger ever
      } else {
        monthlyExpense[dateKey] = [expense]; // Direct assignment triggers ever
      }
    } catch (e) {
      // Handle any errors that occur during the Firestore operation
      // ignore: avoid_print
      print('Error adding expense: $e');
    }
  }

  // Get an expense by ID under a specific user, year, and month
  Future<Expense?> getExpense(
      String userId, int year, int month, String expenseId) async {
    String cacheKey = '$year-$month';

    // First, check the cache
    if (monthlyExpense.containsKey(cacheKey)) {
      var cachedExpense = monthlyExpense[cacheKey]!.firstWhereOrNull(
          (expense) => expense.createdAt.toString() == expenseId);
      if (cachedExpense != null) {
        return cachedExpense;
      }
    }

    // If not found in cache, fetch from Firestore
    try {
      var snapshot = await _db
          .collection('expenses')
          .doc(userId)
          .collection('$year')
          .doc('$month')
          .collection('user expenses')
          .doc(expenseId)
          .get();
      if (snapshot.exists) {
        Expense expense = Expense.fromJson(snapshot.data()!);

        // Optionally, update the cache
        monthlyExpense[cacheKey]!.add(expense);

        return expense;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error retrieving expense: $e');
    }
    return null;
  }

  // Update an expense
  Future<void> updateExpense(Expense expense, String expenseId) async {
    String cacheKey = '${expense.date.year}-${expense.date.month}';

    try {
      // Update the expense in Firestore
      await _db
          .collection('expenses')
          .doc(expense.userId)
          .collection('${expense.date.year}')
          .doc('${expense.date.month}')
          .collection('user expenses')
          .doc(expenseId)
          .update(expense.toJson());

      // If the Firestore operation is successful, update the cache
      if (monthlyExpense.containsKey(cacheKey)) {
        var index = monthlyExpense[cacheKey]!
            .indexWhere((e) => e.createdAt.toString() == expenseId);
        if (index != -1) {
          // Update the existing expense in the cache
          monthlyExpense[cacheKey]![index] = expense;
        }
      }
    } catch (e) {
      // Handle any errors that occur during the Firestore operation
      // ignore: avoid_print
      print('Error updating expense: $e');
    }
  }

  // Delete an expense
  Future<void> deleteExpense(
      String userId, int year, int month, String expenseId) async {
    String cacheKey = '$year-$month';

    try {
      // Delete the expense from Firestore
      await _db
          .collection('expenses')
          .doc(userId)
          .collection('$year')
          .doc('$month')
          .collection('user expenses')
          .doc(expenseId)
          .delete();

      // If the Firestore operation is successful, remove the expense from the cache
      if (monthlyExpense.containsKey(cacheKey)) {
        monthlyExpense[cacheKey]!.removeWhere(
            (expense) => expense.createdAt.toString() == expenseId);
      }
    } catch (e) {
      // Handle any errors that occur during the Firestore operation
      // ignore: avoid_print
      print('Error deleting expense: $e');
    }
  }
}
