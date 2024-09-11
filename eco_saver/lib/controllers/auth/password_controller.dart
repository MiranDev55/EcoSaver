import 'package:get/get.dart';

class LoginController extends GetxController {
  // Reactive variable to track the visibility of the password
  var isPasswordVisible = false.obs;

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
