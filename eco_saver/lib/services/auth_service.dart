import 'package:eco_saver/controllers/budget_controller.dart';
import 'package:eco_saver/controllers/category_controller.dart';
import 'package:eco_saver/controllers/goal_controller.dart';
import 'package:eco_saver/controllers/landing_page_controller.dart';
import 'package:eco_saver/controllers/total_balance_controller.dart';
import 'package:eco_saver/controllers/transaction_controller.dart';
import 'package:eco_saver/services/budget_service.dart';
import 'package:eco_saver/services/expenses_service.dart';
import 'package:eco_saver/services/goal_service.dart';
import 'package:eco_saver/services/incomes_service.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_saver/models/user.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User ID
  RxString userId = ''.obs;

  // Observable user model
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // Bind user ID changes when authentication state changes
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        userId.value = user.uid;
        await _fetchUserData(user.uid);
      }
    });
  }

  // Private method to fetch user data by user ID
  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        userModel.value = UserModel.fromjson(doc);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data: $e');
    }
  }

  // Method to clear user data (e.g., on sign out)
  void clearUserData() {
    userModel.value = null;
    userId.value = ''; // Clear userId when the user logs out
  }

  // Method to check if the user is logged in
  bool isLoggedIn() {
    return userId.isNotEmpty;
  }

  // Sign Up Method
  Future<void> createUser(
      String email, String password, Map<String, dynamic> userDetails) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set(userDetails);
        clearUserData(); // Ensure any pre-existing user data is cleared
        disposeUserDependentControllers(); // Dispose controllers before navigating
        Get.offAllNamed('/login'); // Navigate to login page after sign up
      }
    } catch (e) {
      Get.snackbar('Signup Error', e.toString());
    }
  }

  // Sign In Method
  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      userId.value = userCredential.user?.uid ?? ''; // Update userId
      Get.offNamed('/landing'); // Navigate to landing page after sign in
    } catch (e) {
      Get.snackbar('Login Error', e.toString());
    }
  }

  // Sign Out Method
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Method to dispose of user-dependent controllers
  Future<void> disposeUserDependentControllers() async {
    Get.delete<LandingPageController>(force: true);
    Get.delete<ExpenseController>(force: true);
    Get.delete<IncomeController>(force: true);
    Get.delete<TransactionsController>(force: true);
    Get.delete<CategoryController>(force: true);
    Get.delete<TotalController>(force: true);
    Get.delete<BudgetService>(force: true);
    Get.delete<BudgetController>(force: true);
    Get.delete<GoalService>(force: true);
    Get.delete<GoalController>(force: true);
  }
}
