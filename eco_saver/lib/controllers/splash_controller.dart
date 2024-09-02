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
    print("in _initializeApp");
    // Simulate some loading delay
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is logged in
    if (_authService.isLoggedIn()) {
      print("logged in");
      print("_authService.isLoggedIn() = ${_authService.isLoggedIn()}");
      Get.offNamed('/landing');
    } else {
      print("not logged in");
      print("_authService.isLoggedIn() = ${_authService.isLoggedIn()}");
      Get.offNamed('/login');
    }
  }
}
