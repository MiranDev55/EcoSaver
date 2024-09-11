import 'package:eco_saver/controllers/calculator_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorPopup extends StatelessWidget {
  final Function(double) onAmountEntered;
  final ColorController colorController;

  CalculatorPopup(
      {required this.onAmountEntered,
      super.key,
      required this.colorController});

  final CalculatorController calculatorController =
      Get.put(CalculatorController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Enter Amount",
        style: TextStyle(color: colorController.colorScheme.value.primary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Text(
                calculatorController.input.value.isEmpty
                    ? '0'
                    : calculatorController.input.value,
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: colorController.colorScheme.value.primary),
              )),
          const SizedBox(height: 16),
          _buildNumberPad(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: calculatorController.onClearPress,
          child: Text(
            "Clear",
            style: TextStyle(color: colorController.colorScheme.value.primary),
          ),
        ),
        TextButton(
          onPressed: () => calculatorController.onSubmit(onAmountEntered),
          child: Text(
            "Add",
            style: TextStyle(color: colorController.colorScheme.value.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('4'),
            _buildNumberButton('5'),
            _buildNumberButton('6'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('7'),
            _buildNumberButton('8'),
            _buildNumberButton('9'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('0'),
            _buildNumberButton('.'),
            _buildBackspaceButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          colorController.colorScheme.value.secondary,
        ),
      ),
      onPressed: () => calculatorController.onNumberPress(number),
      child: Text(
        number,
        style: TextStyle(
            fontSize: 24, color: colorController.colorScheme.value.onSecondary),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          colorController.colorScheme.value.secondary,
        ),
      ),
      onPressed: calculatorController.onBackspacePress,
      child: Icon(
        Icons.backspace,
        size: 24,
        color: colorController.colorScheme.value.onSecondary,
      ),
    );
  }
}
