import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/services/auth_service.dart';
import 'package:eco_saver/utils/custom_button.dart';

class LoginPage extends StatelessWidget {
  final ColorController _colorController = Get.find<ColorController>();
  final AuthService _authController = Get.find<AuthService>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorController.colorScheme.value.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60.0),
              Center(
                child: Stack(
                  children: <Widget>[
                    Text(
                      'EcoSaver',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 4
                          ..color = _colorController.colorScheme.value.primary,
                      ),
                    ),
                    Text(
                      'EcoSaver',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: _colorController.colorScheme.value.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Text('Track your pocket with no limits',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: _colorController.colorScheme.value.onSecondary)),
              ),
              const SizedBox(height: 40.0),
              Text('Your email address',
                  style: TextStyle(
                      color: _colorController.colorScheme.value.onSurface,
                      fontWeight: FontWeight.bold)),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color: _colorController.colorScheme.value.onSecondary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color: _colorController.colorScheme.value.onSecondary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color: _colorController.colorScheme.value.secondary,
                        width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text('Choose a password',
                  style: TextStyle(
                      color: _colorController.colorScheme.value.onSurface,
                      fontWeight: FontWeight.bold)),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  suffixIcon: const Icon(Icons.visibility_off),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color: _colorController.colorScheme.value.onSecondary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color: _colorController.colorScheme.value.onSecondary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color: _colorController.colorScheme.value.secondary,
                        width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              CustomButton(
                onPressed: () async {
                  await _authController
                      .signIn(
                    emailController.text,
                    passwordController.text,
                  )
                      .then((result) {
                    if (_authController.isLoggedIn()) {
                      Get.offNamed('/landing'); // Navigate to the landing page
                    }
                  });
                },
                text: 'Continue',
                buttonStyle: CustomButtonStyle.fullWidthStyle(
                    _colorController.colorScheme.value),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: _colorController.colorScheme.value.onSurface,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('or',
                        style: TextStyle(
                            color:
                                _colorController.colorScheme.value.onSurface)),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: _colorController.colorScheme.value.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Center(
                child: SizedBox(
                  width: 100,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.toNamed('/signup');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          _colorController.colorScheme.value.onSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: BorderSide(
                          color: _colorController.colorScheme.value.secondary,
                          width: 2.0),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      'SignUp',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
