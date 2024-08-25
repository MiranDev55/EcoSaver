import 'package:eco_saver/controllers/auth_controller.dart';
import 'package:eco_saver/models/income.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthController authController = Get.find<AuthController>();

  RxMap<String, List<Income>> monthlyIncome =
      RxMap<String, List<Income>>(); // Cache to store incomes by month

  @override
  void onInit() {
    super.onInit();

    // Watch for changes in the user ID and fetch incomes when it changes
    ever(authController.userId, (String userId) {
      if (userId.isNotEmpty) {
        getUserIncomesForCurrentMonth(userId);
      } else {
        // Clear the incomes if the user is not logged in
        monthlyIncome.clear();
      }
    });
  }

  // Method to retrieve incomes for the current month
  Future<void> getUserIncomesForCurrentMonth(String userId) async {
    DateTime now = DateTime.now();
    await getUserIncomesForMonth(userId, now.year, now.month);
  }

  Future<List<Map<String, Income>>> getUserIncomesForMonth(
      String userId, int year, int month) async {
    String cacheKey = '$year-$month';

    if (monthlyIncome.containsKey(cacheKey)) {
      // Transform cached data into a list of map with id and model instance
      return monthlyIncome[cacheKey]!
          .map((income) => {income.createdAt.toString(): income})
          .toList();
    }

    try {
      final snapshot = await _db
          .collection('incomes')
          .doc(userId)
          .collection('$year')
          .doc('$month')
          .collection('user incomes')
          .get();

      List<Map<String, Income>> monthIncomes = snapshot.docs.map((doc) {
        final income = Income.fromJson(doc.data());
        return {doc.id: income}; // Return a map with the document ID as the key
      }).toList();

      // Cache the incomes for this month
      monthlyIncome[cacheKey] =
          monthIncomes.map((map) => map.values.first).toList();

      return monthIncomes;
    } catch (e) {
      // ignore: avoid_print
      print('Error retrieving incomes: $e');
      return [];
    }
  }

  // Create an income for a specific user in a specific year and month
  Future<void> createIncome(Income income) async {
    try {
      String dateKey = '${income.date.year}-${income.date.month}';

      // Add the income to Firestore
      await _db
          .collection('incomes')
          .doc(income.userId)
          .collection('${income.date.year}')
          .doc('${income.date.month}')
          .collection('user incomes')
          .doc() // Firestore generates a unique ID for each income
          .set(income.toJson());

      // If the Firestore operation is successful, update the cache
      if (monthlyIncome.containsKey(dateKey)) {
        // Create a new list to ensure that RxMap detects the change
        final updatedList = List<Income>.from(monthlyIncome[dateKey]!);
        updatedList.add(income);
        monthlyIncome[dateKey] = updatedList; // Reassign to trigger ever
      } else {
        monthlyIncome[dateKey] = [income]; // Direct assignment triggers ever
      }
    } catch (e) {
      // Handle any errors that occur during the Firestore operation
      // ignore: avoid_print
      print('Error adding income: $e');
    }
  }

  // Get incomes for the currently cached months (optional helper method)
  List<Income> getCachedIncomesForMonth(int year, int month) {
    String dateKey = '$year-$month';
    return monthlyIncome[dateKey] ?? [];
  }

  Future<Income?> getIncome(
      String userId, int year, int month, String incomeId) async {
    String cacheKey = '$year-$month';

    // First, check the cache
    if (monthlyIncome.containsKey(cacheKey)) {
      var cachedIncome = monthlyIncome[cacheKey]!.firstWhereOrNull(
          (income) => income.createdAt.toString() == incomeId);
      if (cachedIncome != null) {
        return cachedIncome;
      }
    }

    // If not found in cache, fetch from Firestore
    try {
      var snapshot = await _db
          .collection('incomes')
          .doc(userId)
          .collection('$year')
          .doc('$month')
          .collection('user incomes')
          .doc(incomeId)
          .get();
      if (snapshot.exists) {
        Income income = Income.fromJson(snapshot.data()!);

        // Optionally, update the cache
        monthlyIncome[cacheKey]!.add(income);

        return income;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error retrieving income: $e');
    }
    return null;
  }

  Future<void> updateIncome(Income income, String incomeId) async {
    String cacheKey = '${income.date.year}-${income.date.month}';

    try {
      // Update the income in Firestore
      await _db
          .collection('incomes')
          .doc(income.userId)
          .collection('${income.date.year}')
          .doc('${income.date.month}')
          .collection('user incomes')
          .doc(incomeId)
          .update(income.toJson());

      // If the Firestore operation is successful, update the cache
      if (monthlyIncome.containsKey(cacheKey)) {
        var index = monthlyIncome[cacheKey]!
            .indexWhere((i) => i.createdAt.toString() == incomeId);
        if (index != -1) {
          // Update the existing income in the cache
          monthlyIncome[cacheKey]![index] = income;
        }
      }
    } catch (e) {
      // Handle any errors that occur during the Firestore operation
      // ignore: avoid_print
      print('Error updating income: $e');
    }
  }

  Future<void> deleteIncome(
      String userId, int year, int month, String incomeId) async {
    String cacheKey = '$year-$month';

    try {
      // Delete the income from Firestore
      await _db
          .collection('incomes')
          .doc(userId)
          .collection('$year')
          .doc('$month')
          .collection('user incomes')
          .doc(incomeId)
          .delete();

      // If the Firestore operation is successful, remove the income from the cache
      if (monthlyIncome.containsKey(cacheKey)) {
        monthlyIncome[cacheKey]!
            .removeWhere((income) => income.createdAt.toString() == incomeId);
      }
    } catch (e) {
      // Handle any errors that occur during the Firestore operation
      // ignore: avoid_print
      print('Error deleting income: $e');
    }
  }
}
