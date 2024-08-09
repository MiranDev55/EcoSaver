// navigation_controller.dart
import 'package:get/get.dart';

class NavigationController extends GetxController {
  RxInt currentIndex = 0.obs;

  void changePageIndex(int index) {
    currentIndex.value = index;
  }
}