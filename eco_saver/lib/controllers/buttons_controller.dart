import 'package:get/get.dart';

class ButtonsController extends GetxController {
  var pillButton = 0.obs; // Initially, the first item is selected

  var analystToggleSwitch = 2.obs; // Initially, its on Popular

  var categoryToggleSwitch = 0.obs; // Initially, its on Popular

  void updatePillButton(int index) {
    pillButton.value = index; // Update the selected index
  }

  void updateAnalystToggleSwitch(int index) {
    analystToggleSwitch.value = index; // Update the selected index
  }

  void updateCategoryToggleSwitch(int index) {
    categoryToggleSwitch.value = index; // Update the selected index
  }
}
