import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_saver/models/budget.dart';
import 'package:eco_saver/services/auth_service.dart';
import 'package:get/get.dart';

class BudgetService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final RxMap<String, Budget> categoryBudgets =
      RxMap<String, Budget>(); // Cache to store budgets by category

  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    print("in the onInit of Budget Service");
    getAllBudgets(_authService.userId!);
  }

  // Method to create a budget for a specific category
  Future<void> createBudget(
      String userId, String category, double budgetAmount) async {
    try {
      Budget budget = Budget(
        name: category, // Use the category as the name (document ID)
        budget: budgetAmount,
        dateCreated: DateTime.now(),
        dateModified: DateTime.now(),
      );

      // Create a new document for the category budget
      await _db
          .collection('budgets')
          .doc(userId)
          .collection('categories')
          .doc(category)
          .set(budget.toFirestore());

      // Cache the budget locally
      categoryBudgets[category] = budget;
      categoryBudgets.refresh();
    } catch (e) {
      // ignore: avoid_print
      print('Error creating budget: $e');
    }
  }

  // Method to get all budgets
  Future<Map<String, double>> getAllBudgets(String userId) async {
    print("in the getAllBudgets");
    Map<String, double> budgets = {};

    try {
      QuerySnapshot snapshot = await _db
          .collection('budgets')
          .doc(userId)
          .collection('categories')
          .get();

      for (var doc in snapshot.docs) {
        String category = doc.id;
        Budget budget =
            Budget.fromFirestore(category, doc.data() as Map<String, dynamic>);

        // Cache the budget data
        categoryBudgets[category] = budget;
        budgets[category] = budget.budget;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error retrieving all budgets: $e');
    }

    return budgets;
  }

  // Method to update a budget for a specific category
  Future<void> updateBudget(
      String userId, String category, double budgetAmount) async {
    try {
      DateTime now = DateTime.now();

      // Update the existing document for the category budget
      await _db
          .collection('budgets')
          .doc(userId)
          .collection('categories')
          .doc(category)
          .update({
        'budget': budgetAmount,
        'dateModified': FieldValue.serverTimestamp(),
      });

      // Update the cached budget
      if (categoryBudgets.containsKey(category)) {
        categoryBudgets[category] = Budget(
          name: category,
          budget: budgetAmount,
          dateCreated: categoryBudgets[category]!
              .dateCreated, // Keep the original creation date
          dateModified: now,
        );
        categoryBudgets.refresh();
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error updating budget: $e');
    }
  }

  // Method to delete a budget for a specific category
  Future<void> deleteBudget(String userId, String category) async {
    try {
      // Delete the document for the category budget
      await _db
          .collection('budgets')
          .doc(userId)
          .collection('categories')
          .doc(category)
          .delete();

      // Remove from local cache
      categoryBudgets.remove(category);
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting budget: $e');
    }
  }

  // Method to get a budget for a specific category
// Method to get a budget for a specific category
  Future<Budget?> getBudget(String userId, String category) async {
    if (categoryBudgets.containsKey(category)) {
      return categoryBudgets[category]; // Return Budget from the cache
    }

    try {
      DocumentSnapshot snapshot = await _db
          .collection('budgets')
          .doc(userId)
          .collection('categories')
          .doc(category)
          .get();

      if (snapshot.exists) {
        Budget budget = Budget.fromFirestore(
            category, snapshot.data() as Map<String, dynamic>);

        // Cache the budget data
        categoryBudgets[category] = budget;

        return budget; // Return the Budget object
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error retrieving budget: $e');
    }

    return null;
  }

  // // Method to get a budget for a specific category
  // Future<Budget?> getBudget(String userId, String category) async {
  //   if (categoryBudgets.containsKey(category)) {
  //     return categoryBudgets[category]!;
  //   }

  //   try {
  //     DocumentSnapshot snapshot = await _db
  //         .collection('budgets')
  //         .doc(userId)
  //         .collection('categories')
  //         .doc(category)
  //         .get();

  //     if (snapshot.exists) {
  //       Budget budget = Budget.fromFirestore(
  //           category, snapshot.data() as Map<String, dynamic>);

  //       // Cache the budget data
  //       categoryBudgets[category] = budget;

  //       return budget;
  //     }
  //   } catch (e) {
  //     print('Error retrieving budget: $e');
  //   }

  //   return null;
  // }
}
