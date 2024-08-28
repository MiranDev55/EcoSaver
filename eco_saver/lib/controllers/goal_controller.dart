import 'package:eco_saver/models/goals.dart';
import 'package:eco_saver/services/goal_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class GoalController extends GetxController {
  final GoalService _goalService =
      Get.find<GoalService>(); // Dependency injection
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  RxMap<String, Goal> goalsMap = RxMap<String, Goal>(); // key is the id

  @override
  void onInit() {
    super.onInit();

    // Fetch and listen to goals on initialization
    fetchGoals();

    // Listen to changes in the cached goals from GoalService
    ever(_goalService.cachedGoals, (_) {
      _syncGoalsWithCache();
    });
  }

  // Sync goalsMap with cachedGoals whenever the cache updates
  void _syncGoalsWithCache() {
    final Map<String, Goal> syncedGoals =
        _goalService.cachedGoals.map((id, data) {
      return MapEntry(
        id,
        Goal(
          id: id,
          goalName: data['goalName'],
          targetAmount: data['targetAmount'],
          amountSaved: data['amountSaved'],
          createdAt: data['createdAt'],
          notes: data['notes'],
          priority: data['priority'],
          status: data['status'],
        ),
      );
    });

    goalsMap.assignAll(syncedGoals);
  }

  // Function to fetch all goals and populate the goalsMap
  Future<void> fetchGoals() async {
    try {
      // Fetch all goals from GoalService
      final allGoalsMap = await _goalService.getAllGoals(userId);

      // Convert the Map<String, Map<String, dynamic>> to Map<String, Goal>
      final Map<String, Goal> fetchedGoals = allGoalsMap.map((id, data) {
        return MapEntry(
          id,
          Goal(
            id: id,
            goalName: data['goalName'],
            targetAmount: data['targetAmount'],
            amountSaved: data['amountSaved'],
            createdAt: data['createdAt'],
            notes: data['notes'],
            priority: data['priority'],
            status: data['status'],
          ),
        );
      });

      // Update the goalsMap with the fetched goals
      goalsMap.assignAll(fetchedGoals);
    } catch (e) {
      // ignore: avoid_print
      print("Failed to fetch goals: $e");
    }
  }

  // Additional CRUD methods as needed
  Future<void> addGoal({
    required String goalName,
    required double targetAmount,
    double amountSaved = 0.0,
    String? notes,
    String? priority,
    String status = "Active",
  }) async {
    try {
      await _goalService.createGoal(
        userId: userId,
        goalName: goalName,
        targetAmount: targetAmount,
        amountSaved: amountSaved,
        notes: notes,
        priority: priority,
        status: status,
      );

      // After adding a goal, fetch the updated list
      fetchGoals();
    } catch (e) {
      // ignore: avoid_print
      print("Failed to add goal: $e");
    }
  }

  Future<void> updateGoal({
    required String goalId,
    String? goalName,
    double? targetAmount,
    double? amountSaved,
    String? notes,
    String? priority,
    String? status,
  }) async {
    try {
      await _goalService.updateGoal(
        userId: userId,
        goalId: goalId,
        goalName: goalName,
        targetAmount: targetAmount,
        amountSaved: amountSaved,
        notes: notes,
        priority: priority,
        status: status,
      );

      // After updating a goal, fetch the updated list
      fetchGoals();
    } catch (e) {
      // ignore: avoid_print
      print("Failed to update goal: $e");
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      await _goalService.deleteGoal(userId, goalId);

      // After deleting a goal, fetch the updated list
      fetchGoals();
    } catch (e) {
      // ignore: avoid_print
      print("Failed to delete goal: $e");
    }
  }
}
