import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BudgetService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final RxMap<String, Map<String, dynamic>> categoryBudgets = RxMap<String,
      Map<String, dynamic>>(); // Cache to store budgets by category

  // Method to create a budget for a specific category
  Future<void> createBudget(
      String userId, String category, double budget) async {
    try {
      // Create a new document for the category budget
      await _db
          .collection('budgets')
          .doc(userId)
          .collection('categories')
          .doc(category)
          .set({
        'budget': budget,
        'dateCreated': FieldValue.serverTimestamp(),
        'dateModified': FieldValue.serverTimestamp(),
      });

      // Cache the budget locally
      categoryBudgets[category] = {
        'budget': budget,
        'dateCreated': DateTime.now(),
        'dateModified': DateTime.now(),
      };

      categoryBudgets.refresh();
    } catch (e) {
      // ignore: avoid_print
      print('Error creating budget: $e');
    }
  }

  // Method to update a budget for a specific category
  Future<void> updateBudget(
      String userId, String category, double budget) async {
    try {
      // Update the existing document for the category budget
      await _db
          .collection('budgets')
          .doc(userId)
          .collection('categories')
          .doc(category)
          .update({
        'budget': budget,
        'dateModified': FieldValue.serverTimestamp(),
      });

      // Update the cached budget
      if (categoryBudgets.containsKey(category)) {
        categoryBudgets[category]!['budget'] = budget;
        categoryBudgets[category]!['dateModified'] = DateTime.now();
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

      //categoryBudgets.refresh();
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting budget: $e');
    }
  }

  // Method to get a budget for a specific category
  Future<double?> getBudget(String userId, String category) async {
    if (categoryBudgets.containsKey(category)) {
      return categoryBudgets[category]!['budget'];
    }

    try {
      DocumentSnapshot snapshot = await _db
          .collection('budgets')
          .doc(userId)
          .collection('categories')
          .doc(category)
          .get();

      if (snapshot.exists) {
        double budget = snapshot['budget'];

        // Cache the budget data
        categoryBudgets[category] = {
          'budget': budget,
          'dateCreated': (snapshot['dateCreated'] as Timestamp).toDate(),
          'dateModified': (snapshot['dateModified'] as Timestamp).toDate(),
        };

        return budget;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error retrieving budget: $e');
    }

    return null;
  }

  // Method to get all budgets
  Future<Map<String, double>> getAllBudgets(String userId) async {
    Map<String, double> budgets = {};

    try {
      QuerySnapshot snapshot = await _db
          .collection('budgets')
          .doc(userId)
          .collection('categories')
          .get();

      for (var doc in snapshot.docs) {
        String category = doc.id;
        double budget = doc['budget'];

        // Cache the budget data
        categoryBudgets[category] = {
          'budget': budget,
          'dateCreated': (doc['dateCreated'] as Timestamp).toDate(),
          'dateModified': (doc['dateModified'] as Timestamp).toDate(),
        };

        budgets[category] = budget;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error retrieving all budgets: $e');
    }

    return budgets;
  }
}
