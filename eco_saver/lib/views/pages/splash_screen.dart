import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/services/auth_service.dart';
import 'package:eco_saver/views/pages/auth_pages/login_page.dart';

class SplashScreen extends StatelessWidget {
  final ColorController _colorController = Get.find<ColorController>();

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check authentication status after 2 seconds and route accordingly
    Future.delayed(const Duration(seconds: 2), () async {
      final AuthService authService = Get.find<AuthService>();

      if (authService.userId != null) {
        // User is logged in, fetch the user data and go to landing page
        await authService.fetchUserData();
        // Navigate using the named route to ensure bindings are applied
        Get.offAllNamed('/landing');
      } else {
        // User is not logged in, navigate to login page
        Get.offAll(() => LoginPage());
      }
    });

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
