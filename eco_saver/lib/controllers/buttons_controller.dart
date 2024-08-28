import 'package:get/get.dart';

class ButtonsController extends GetxController {
  // Transaction Floating Button TFB
  var isTFBExpanded = false.obs;

  void toggleTFB() {
    isTFBExpanded.value = !isTFBExpanded.value;
  }

  void closeTFB() {
    isTFBExpanded.value = false;
  }
}
