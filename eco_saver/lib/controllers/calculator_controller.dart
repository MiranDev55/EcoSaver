import 'package:get/get.dart';

class CalculatorController extends GetxController {
  var input = ''.obs;

  // Method to handle number press
  void onNumberPress(String number) {
    input.value += number;
  }

  // Method to handle clear press
  void onClearPress() {
    input.value = '';
  }

  // Method to handle backspace press
  void onBackspacePress() {
    if (input.value.isNotEmpty) {
      input.value = input.value.substring(0, input.value.length - 1);
    }
  }

  // Method to handle submit press
  void onSubmit(Function(double) onAmountEntered) {
    if (input.value.isNotEmpty) {
      double enteredAmount = double.parse(input.value);
      onAmountEntered(enteredAmount);
      Get.back();
    }
  }
}
