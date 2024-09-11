import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Add Firebase Storage import

class SignupController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  var selectedImagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();

    ever(selectedImagePath, ((sip) {
      print("imaged updated new image value: $sip");
      Get.snackbar('imaged updated', '');
    }));
  }

  // Method to pick image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    } else {
      Get.snackbar('Error', 'No image selected');
    }
  }

  // Method to clear the selected image
  void clearImage() {
    selectedImagePath.value = '';
  }

  // Upload image to Firebase Storage in a folder with userId and return download URL
  Future<String?> uploadImageToFirebase(String userId) async {
    if (selectedImagePath.value.isNotEmpty) {
      try {
        File file = File(selectedImagePath.value);
        String fileName = 'profile_$userId.jpg'; // Set a unique filename
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('user_profiles')
            .child(userId)
            .child(fileName);

        // Start upload
        UploadTask uploadTask = storageRef.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        return downloadUrl; // Return the download URL for Firestore or other use
      } catch (e) {
        Get.snackbar('Error', 'Failed to upload image: $e');
      }
    }
    return null; // Return null if no image was selected or upload failed
  }
}
