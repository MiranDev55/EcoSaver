import 'package:eco_saver/services/auth_service.dart';
import 'package:eco_saver/models/expense.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthService authController = Get.find<AuthService>();

  // Cache to store expenses by month and document ID
  RxMap<String, Map<String, List<Expense>>> monthlyExpense =
      RxMap<String, Map<String, List<Expense>>>();

  // @override
  // void onInit() {
  //   super.onInit();

  //   // Watch for changes in the user ID and fetch expenses when it changes
  //   ever(authController.userId, (String userId) {
  //     //print("userId for Expenses = $userId");
  //     if (userId.isNotEmpty) {
  //       //print("userId for Expenses = $userId");
  //       getUserExpensesForCurrentMonth(userId);
  //     } else {
  //       //print("userId for Expenses = $userId");
  //       // Clear the expenses if the user is not logged in
  //       monthlyExpense.clear();
  //     }
  //   });
  // }

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
          .entries
          .map((entry) => {entry.key: entry.value.first})
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

      Map<String, List<Expense>> monthExpenses = {
        for (var doc in snapshot.docs) doc.id: [Expense.fromJson(doc.data())]
      };

      // Cache the expenses for this month
      monthlyExpense[cacheKey] = monthExpenses;

      return monthExpenses.entries
          .map((entry) => {entry.key: entry.value.first})
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error retrieving expenses: $e');
      return [];
    }
  }

  // Create an expense for a specific user in a specific year and month
  Future<String?> createExpense(Expense expense) async {
    try {
      String dateKey = '${expense.date.year}-${expense.date.month}';

      // Create a reference to the new document
      DocumentReference docRef = _db
          .collection('expenses')
          .doc(expense.userId)
          .collection('${expense.date.year}')
          .doc('${expense.date.month}')
          .collection('user expenses')
          .doc();

      // Set the expense data to the document
      await docRef.set(expense.toJson());

      String documentId = docRef.id;

      // If the Firestore operation is successful, update the cache
      if (monthlyExpense.containsKey(dateKey)) {
        if (monthlyExpense[dateKey]!.containsKey(documentId)) {
          monthlyExpense[dateKey]![documentId]!.add(expense);
        } else {
          monthlyExpense[dateKey]![documentId] = [expense];
        }
      } else {
        monthlyExpense[dateKey] = {
          documentId: [expense]
        };
      }

      return documentId;
    } catch (e) {
      // Handle any errors that occur during the Firestore operation
      // ignore: avoid_print
      print('Error adding expense: $e');
      return null;
    }
  }

  // Get an expense by ID under a specific user, year, and month
  Future<Expense?> getExpense(
      String userId, int year, int month, String expenseId) async {
    String cacheKey = '$year-$month';

    // First, check the cache
    if (monthlyExpense.containsKey(cacheKey)) {
      var cachedExpense = monthlyExpense[cacheKey]![expenseId]?.first;
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
        if (monthlyExpense.containsKey(cacheKey)) {
          if (monthlyExpense[cacheKey]!.containsKey(expenseId)) {
            monthlyExpense[cacheKey]![expenseId]!.add(expense);
          } else {
            monthlyExpense[cacheKey]![expenseId] = [expense];
          }
        } else {
          monthlyExpense[cacheKey] = {
            expenseId: [expense]
          };
        }

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
        if (monthlyExpense[cacheKey]!.containsKey(expenseId)) {
          monthlyExpense[cacheKey]![expenseId] = [expense];

          // Notify that the map has been updated
          monthlyExpense.refresh();
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
        monthlyExpense[cacheKey]!.remove(expenseId);
      }
    } catch (e) {
      // Handle any errors that occur during the Firestore operation
      // ignore: avoid_print
      print('Error deleting expense: $e');
    }
  }
}
