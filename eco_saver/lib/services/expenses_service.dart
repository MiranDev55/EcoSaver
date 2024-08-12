import 'package:eco_saver/models/expense.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RxList<Expense> expenses = RxList<Expense>(); // Reactive list of expenses

  // Create an expense for a specific user
  Future<void> createExpense(Expense expense) async {
    await _db
        .collection('expenses')
        .doc(expense.userId)
        .collection('user expenses')
        .doc() // Firestore generates a unique ID for each expense
        .set(expense.toJson());
  }

  // Get an expense by ID under a specific user
  Future<Expense?> getExpense(String userId, String expenseId) async {
    var snapshot = await _db
        .collection('expenses')
        .doc(userId)
        .collection('user expenses')
        .doc(expenseId)
        .get();
    if (snapshot.exists) {
      return Expense.fromJson(snapshot.data()!);
    }
    return null;
  }

  // Update an expense
  Future<void> updateExpense(Expense expense, String expenseId) async {
    await _db
        .collection('expenses')
        .doc(expense.userId)
        .collection('user expenses')
        .doc(expenseId)
        .update(expense.toJson());
  }

  // Delete an expense
  Future<void> deleteExpense(String userId, String expenseId) async {
    await _db
        .collection('expenses')
        .doc(userId)
        .collection('user expenses')
        .doc(expenseId)
        .delete();
  }

  // Watch all expenses for a specific user
  void watchUserExpenses(String userId) {
    expenses.bindStream(_db
        .collection('expenses')
        .doc(userId)
        .collection('user expenses')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Expense.fromJson(doc.data())).toList()));
  }
}
