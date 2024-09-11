import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eco_saver/controllers/color_controller.dart';

class SplashScreen extends StatelessWidget {
  // ignore: unused_field
  //final SplashController _splashController = Get.put(SplashController());
  final ColorController _colorController = Get.find<ColorController>();

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorController.colorScheme.value.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: _colorController.colorScheme.value.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'EcoSaver',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: _colorController.colorScheme.value.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16.0,
                color: _colorController.colorScheme.value.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
