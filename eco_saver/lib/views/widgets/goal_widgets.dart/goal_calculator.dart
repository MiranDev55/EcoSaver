import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorPopup extends StatefulWidget {
  final Function(double) onAmountEntered;

  const CalculatorPopup({required this.onAmountEntered, Key? key})
      : super(key: key);

  @override
  _CalculatorPopupState createState() => _CalculatorPopupState();
}

class _CalculatorPopupState extends State<CalculatorPopup> {
  String _input = '';

  void _onNumberPress(String number) {
    setState(() {
      _input += number;
    });
  }

  void _onClearPress() {
    setState(() {
      _input = '';
    });
  }

  void _onBackspacePress() {
    if (_input.isNotEmpty) {
      setState(() {
        _input = _input.substring(0, _input.length - 1);
      });
    }
  }

  void _onSubmitPress() {
    if (_input.isNotEmpty) {
      double enteredAmount = double.parse(_input);
      widget.onAmountEntered(enteredAmount);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enter Amount"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _input.isEmpty ? '0' : _input,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildNumberPad(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _onClearPress,
          child: const Text("Clear"),
        ),
        TextButton(
          onPressed: _onSubmitPress,
          child: const Text("Add"),
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
      onPressed: () => _onNumberPress(number),
      child: Text(
        number,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return ElevatedButton(
      onPressed: _onBackspacePress,
      child: const Icon(Icons.backspace, size: 24),
    );
  }
}
