import 'package:eco_saver/services/auth_service.dart';
import 'package:eco_saver/models/income.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthService authController = Get.find<AuthService>();

  // Cache to store incomes by month and document ID
  RxMap<String, Map<String, List<Income>>> monthlyIncome =
      RxMap<String, Map<String, List<Income>>>();

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
          .entries
          .map((entry) => {entry.key: entry.value.first})
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

      Map<String, List<Income>> monthIncomes = {
        for (var doc in snapshot.docs) doc.id: [Income.fromJson(doc.data())]
      };

      // Cache the incomes for this month
      monthlyIncome[cacheKey] = monthIncomes;

      return monthIncomes.entries
          .map((entry) => {entry.key: entry.value.first})
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error retrieving incomes: $e');
      return [];
    }
  }

  // Create an income for a specific user in a specific year and month
  Future<String?> createIncome(Income income) async {
    try {
      String dateKey = '${income.date.year}-${income.date.month}';

      // Create a reference to the new document
      DocumentReference docRef = _db
          .collection('incomes')
          .doc(income.userId)
          .collection('${income.date.year}')
          .doc('${income.date.month}')
          .collection('user incomes')
          .doc();

      // Set the income data to the document
      await docRef.set(income.toJson());

      String documentId = docRef.id;

      // If the Firestore operation is successful, update the cache
      if (monthlyIncome.containsKey(dateKey)) {
        if (monthlyIncome[dateKey]!.containsKey(documentId)) {
          monthlyIncome[dateKey]![documentId]!.add(income);
        } else {
          monthlyIncome[dateKey]![documentId] = [income];
        }
      } else {
        monthlyIncome[dateKey] = {
          documentId: [income]
        };
      }

      return documentId;
    } catch (e) {
      // Handle any errors that occur during the Firestore operation
      // ignore: avoid_print
      print('Error adding income: $e');
      return null;
    }
  }

  // Get an income by ID under a specific user, year, and month
  Future<Income?> getIncome(
      String userId, int year, int month, String incomeId) async {
    String cacheKey = '$year-$month';

    // First, check the cache
    if (monthlyIncome.containsKey(cacheKey)) {
      var cachedIncome = monthlyIncome[cacheKey]![incomeId]?.first;
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
        if (monthlyIncome.containsKey(cacheKey)) {
          if (monthlyIncome[cacheKey]!.containsKey(incomeId)) {
            monthlyIncome[cacheKey]![incomeId]!.add(income);
          } else {
            monthlyIncome[cacheKey]![incomeId] = [income];
          }
        } else {
          monthlyIncome[cacheKey] = {
            incomeId: [income]
          };
        }

        return income;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error retrieving income: $e');
    }
    return null;
  }

  // Update an income
  Future<void> updateIncome(Income income, String incomeId) async {
    String cacheKey = '${income.date.year}-${income.date.month}';

    try {
      //print("id = $incomeId");
      //print("before updating");
      // Update the income in Firestore
      await _db
          .collection('incomes')
          .doc(income.userId)
          .collection('${income.date.year}')
          .doc('${income.date.month}')
          .collection('user incomes')
          .doc(incomeId)
          .update(income.toJson());

      //print("after updating");

      // If the Firestore operation is successful, update the cache
      if (monthlyIncome.containsKey(cacheKey)) {
        if (monthlyIncome[cacheKey]!.containsKey(incomeId)) {
          monthlyIncome[cacheKey]![incomeId] = [income];

          // Notify that the map has been updated
          monthlyIncome.refresh();
        }
      }
    } catch (e) {
      // Handle any errors that occur during the Firestore operation
      // ignore: avoid_print
      print('Error updating income: $e');
    }
  }

  // Delete an income
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
        monthlyIncome[cacheKey]!.remove(incomeId);
      }
    } catch (e) {
      // Handle any errors that occur during the Firestore operation
      // ignore: avoid_print
      print('Error deleting income: $e');
    }
  }
}
