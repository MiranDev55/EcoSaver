import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_saver/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  static AuthService instance = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var userModel = Rxn<UserModel>(); // Observable UserModel, starts as null

  String? get userId {
    return auth.currentUser?.uid;
  }

  // Fetch user data and update userModel
  Future<void> fetchUserData() async {
    try {
      if (userId != null) {
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(userId).get();

        if (userDoc.exists) {
          userModel.value = UserModel.fromDocumentSnapshot(userDoc);
        } else {
          Get.snackbar("Error", "User data not found in Firestore");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data: $e");
    }
  }

  // Create and save new user data in Firestore
  Future<void> createUser(
      String email, String password, String username) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user!.uid;

      // Create a new UserModel object
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        username: username,
        profilePic: '',
        createdAt: DateTime.now(),
      );

      // Save user data in Firestore
      await firestore.collection('users').doc(uid).set(newUser.toMap());

      // Update local userModel
      userModel.value = newUser;

      Get.offAllNamed("/landing");
    } catch (e) {
      Get.snackbar("Error creating account", e.toString());
    }
  }

  // Login user and fetch their data from Firestore
  Future<void> loginUser(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      await fetchUserData(); // Fetch and store user data in userModel after login
      Get.offAllNamed("/landing");
    } catch (e) {
      Get.snackbar("Error logging in", e.toString());
    }
  }

  // Update user data in Firestore and the local userModel
  Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    try {
      if (userId != null) {
        await firestore.collection('users').doc(userId).update(updatedData);

        // Update the local userModel
        userModel.value = UserModel(
          uid: userModel.value?.uid ?? '',
          email: updatedData['email'] ?? userModel.value?.email ?? '',
          username: updatedData['username'] ?? userModel.value?.username ?? '',
          profilePic:
              updatedData['profilePic'] ?? userModel.value?.profilePic ?? '',
          createdAt: userModel.value?.createdAt,
        );

        Get.snackbar("Success", "User data updated");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update user data: $e");
    }
  }

  // Logout and clear userModel
  Future<void> logout() async {
    await auth.signOut();
    userModel.value = null; // Clear user data on logout
    Get.offAllNamed("/login");
  }
}
