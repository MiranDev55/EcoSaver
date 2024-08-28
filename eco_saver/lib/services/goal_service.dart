import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GoalService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxMap<String, Map<String, dynamic>> cachedGoals =
      RxMap<String, Map<String, dynamic>>();

  // Create a new goal
  Future<void> createGoal({
    required String userId,
    required String goalName,
    required double targetAmount,
    double amountSaved = 0.0,
    String? notes,
    String? priority,
    String status = "Active",
  }) async {
    try {
      CollectionReference userGoalsCollection =
          _firestore.collection('goals').doc(userId).collection('userGoals');

      DocumentReference newGoalDoc = userGoalsCollection
          .doc(); // Create a new document with an auto-generated ID

      await newGoalDoc.set({
        'goalName': goalName,
        'targetAmount': targetAmount,
        'amountSaved': amountSaved,
        'createdAt': FieldValue.serverTimestamp(),
        'notes': notes,
        'priority': priority,
        'status': status,
      });

      // Cache the goal locally with the goal ID
      cachedGoals[newGoalDoc.id] = {
        'goalName': goalName,
        'targetAmount': targetAmount,
        'amountSaved': amountSaved,
        'createdAt': DateTime.now(),
        'notes': notes,
        'priority': priority,
        'status': status,
      };

      cachedGoals.refresh();

      print("Goal created successfully");
    } catch (e) {
      // ignore: avoid_print
      print("Failed to create goal: $e");
    }
  }

  // Read a goal by userId and goalId
  Future<Map<String, dynamic>?> getGoal(String userId, String goalId) async {
    if (cachedGoals.containsKey(goalId)) {
      return cachedGoals[goalId];
    }

    try {
      DocumentSnapshot doc = await _firestore
          .collection('goals')
          .doc(userId)
          .collection('userGoals')
          .doc(goalId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> goalData = {
          'goalName': doc['goalName'],
          'targetAmount': doc['targetAmount'],
          'amountSaved': doc['amountSaved'],
          'createdAt': (doc['createdAt'] as Timestamp).toDate(),
          'notes': doc['notes'],
          'priority': doc['priority'],
          'status': doc['status'],
        };

        // Cache the goal data
        cachedGoals[goalId] = goalData;

        return goalData;
      }
    } catch (e) {
      print("Failed to get goal: $e");
    }

    return null;
  }

  // Update an existing goal
  Future<void> updateGoal({
    required String userId,
    required String goalId,
    String? goalName,
    double? targetAmount,
    double? amountSaved,
    String? notes,
    String? priority,
    String? status,
  }) async {
    try {
      DocumentReference docRef = _firestore
          .collection('goals')
          .doc(userId)
          .collection('userGoals')
          .doc(goalId);

      Map<String, dynamic> updatedData = {};

      if (goalName != null) updatedData['goalName'] = goalName;
      if (targetAmount != null) updatedData['targetAmount'] = targetAmount;
      if (amountSaved != null) updatedData['amountSaved'] = amountSaved;
      if (notes != null) updatedData['notes'] = notes;
      if (priority != null) updatedData['priority'] = priority;
      if (status != null) updatedData['status'] = status;

      await docRef.update(updatedData);

      // Update the cached goal
      if (cachedGoals.containsKey(goalId)) {
        cachedGoals[goalId]!.addAll(updatedData);
        cachedGoals[goalId]!['dateModified'] = DateTime.now();
        cachedGoals.refresh();
      }

      print("Goal updated successfully");
    } catch (e) {
      print("Failed to update goal: $e");
    }
  }

  // Delete a goal by userId and goalId
  Future<void> deleteGoal(String userId, String goalId) async {
    try {
      DocumentReference docRef = _firestore
          .collection('goals')
          .doc(userId)
          .collection('userGoals')
          .doc(goalId);

      await docRef.delete();

      // Remove from local cache
      cachedGoals.remove(goalId);
      cachedGoals.refresh();

      print("Goal deleted successfully");
    } catch (e) {
      print("Failed to delete goal: $e");
    }
  }

  // Get all goals for a user
  Future<Map<String, Map<String, dynamic>>> getAllGoals(String userId) async {
    if (cachedGoals.isNotEmpty) {
      return cachedGoals;
    }

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('goals')
          .doc(userId)
          .collection('userGoals')
          .get();

      Map<String, Map<String, dynamic>> allGoals = {};

      for (var doc in querySnapshot.docs) {
        String goalId = doc.id;
        Map<String, dynamic> goalData = {
          'goalName': doc['goalName'],
          'targetAmount': doc['targetAmount'],
          'amountSaved': doc['amountSaved'],
          'createdAt': (doc['createdAt'] as Timestamp).toDate(),
          'notes': doc['notes'],
          'priority': doc['priority'],
          'status': doc['status'],
        };

        // Cache the goal data
        allGoals[goalId] = goalData;
      }

      // Update local cache with all goals
      cachedGoals.addAll(allGoals);
      cachedGoals.refresh();

      return allGoals;
    } catch (e) {
      print("Failed to get all goals: $e");
    }

    return {};
  }
}
