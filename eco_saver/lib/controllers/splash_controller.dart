import 'package:get/get.dart';
import 'package:eco_saver/services/auth_service.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate some loading delay
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is logged in
    if (_authService.isLoggedIn()) {
      Get.offNamed('/landing');
    } else {
      Get.offNamed('/login');
    }
  }
}
