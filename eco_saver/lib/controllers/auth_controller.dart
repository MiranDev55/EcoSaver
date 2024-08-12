import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User authentication status
  Rxn<User> firebaseUser = Rxn<User>();

  // User ID
  RxString userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Bind user changes
    firebaseUser.bindStream(_auth.authStateChanges());

    // Update user ID when authentication state changes
    ever(firebaseUser, (User? user) {
      userId.value = user?.uid ?? '';
    });
  }

  // Method to check if the user is logged in
  bool isLoggedIn() {
    return _auth.currentUser != null;
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
        Get.offNamed('/landing'); // Navigate to landing page after sign up
      }
    } catch (e) {
      Get.snackbar('Signup Error', e.toString());
    }
  }

  // Sign In Method
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offNamed('/landing'); // Navigate to landing page after sign in
    } catch (e) {
      Get.snackbar('Login Error', e.toString());
    }
  }

  // Sign Out Method
  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAllNamed('/login'); // Redirect to login page after sign out
  }
}
