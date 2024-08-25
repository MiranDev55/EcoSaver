import 'package:eco_saver/controllers/auth_controller.dart';
import 'package:eco_saver/utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eco_saver/controllers/color_controller.dart';

class LoginPage extends StatelessWidget {
  final ColorController _colorController = Get.find<ColorController>();
  final AuthController _authController = Get.find<AuthController>();
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
                    // Stroked text as border.
                    Text(
                      'EcoSaver',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 4
                          ..color = _colorController.colorScheme.value
                              .primary, // Choose an appropriate color for the outline
                      ),
                    ),
                    // Solid text as fill.
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
                child: Text('Track your pocket with no imits',
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
                        color: _colorController.colorScheme.value
                            .onSecondary), // Default border color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color: _colorController.colorScheme.value
                            .onSecondary), // Border color when the TextField is enabled
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color: _colorController.colorScheme.value.secondary,
                        width:
                            2.0), // Border color when the TextField is focused
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
                  hintStyle: const TextStyle(
                      fontWeight:
                          FontWeight.normal), // Normal weight for hint text
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  suffixIcon: const Icon(Icons.visibility_off),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color: _colorController.colorScheme.value
                            .onSecondary), // Default border color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color: _colorController.colorScheme.value
                            .onSecondary), // Border color when the TextField is enabled
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color: _colorController.colorScheme.value.secondary,
                        width:
                            2.0), // Border color when the TextField is focused
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              // ElevatedButton(
              //   onPressed: () {
              //     _authController.signIn(
              //         emailController.text, passwordController.text);
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: _colorController.colorScheme.value.secondary,
              //     foregroundColor:
              //         _colorController.colorScheme.value.onSecondary,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(30.0)),
              //     minimumSize: const Size(double.infinity, 50),
              //   ),
              //   child: const Text(
              //     'Continue',
              //     style: TextStyle(fontWeight: FontWeight.bold),
              //   ),
              // ),

              CustomButton(
                  onPressed: () {
                    _authController.signIn(
                        emailController.text, passwordController.text);
                  },
                  text: 'Continue',
                  buttonStyle: CustomButtonStyle.fullWidthStyle(
                      _colorController.colorScheme.value)),

              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                        thickness: 2,
                        color: _colorController.colorScheme.value.onSurface),
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
                        color: _colorController.colorScheme.value.onSurface),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Center(
                // Center to wrap the button
                child: SizedBox(
                  width: 100, // Specify the width
                  child: OutlinedButton(
                    onPressed: () {
                      Get.toNamed('/signup'); // Navigates to the signup page
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          _colorController.colorScheme.value.onSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: const BorderSide(
                          color: Colors.yellow,
                          width: 2.0), // Setting a yellow border
                      minimumSize: const Size.fromHeight(
                          50), // Use fromHeight for consistent height
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
