import 'package:eco_saver/controllers/auth/splash_controller.dart';
import 'package:get/get.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    _initializeUserDependentControllers();
  }

  void _initializeUserDependentControllers() {
    Get.put(SplashController());
  }
}
