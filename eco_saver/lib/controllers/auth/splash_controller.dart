import 'package:get/get.dart';
import 'package:eco_saver/services/auth_service.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  // Future<void> _initializeApp() async {
  //   // Simulate some loading delay
  //   await Future.delayed(const Duration(seconds: 2));

  //   // Check if user is logged in
  //   if (_authService.isLoggedIn()) {
  //     Get.offNamed('/landing');
  //   } else {
  //     Get.offNamed('/login');
  //   }
  // }

  Future<void> _initializeApp() async {
    // Simulate some loading delay
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is logged in
    if (_authService.isLoggedIn()) {
      bool isValidUser = await _authService.checkUserTokenValidity();
      if (isValidUser) {
        Get.offNamed('/landing');
      } else {
        // If user token is invalid (user doesn't exist), log out and go to login page
        await _authService.signOut();
        Get.offNamed('/login');
      }
    } else {
      Get.offNamed('/login');
    }
  }
}
