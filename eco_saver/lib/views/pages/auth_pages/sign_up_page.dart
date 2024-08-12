import 'package:eco_saver/controllers/auth_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ColorController _colorController = Get.find<ColorController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Create Account',
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
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: _colorController.colorScheme.value.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              Text('Your email address',
                  style: TextStyle(
                      color: _colorController.colorScheme.value.onSurface)),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
              const SizedBox(height: 20.0),
              Text('Choose a password',
                  style: TextStyle(
                      color: _colorController.colorScheme.value.onSurface)),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  suffixIcon: const Icon(Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 20.0),
              Text('Your name',
                  style: TextStyle(
                      color: _colorController.colorScheme.value.onSurface)),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> userDetails = {
                    'email': emailController.text,
                    'name': nameController.text,
                    'createdAt': DateTime.now(),
                    // Add other fields if needed
                  };
                  authController.createUser(emailController.text,
                      passwordController.text, userDetails);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _colorController.colorScheme.value.secondary,
                  foregroundColor:
                      _colorController.colorScheme.value.onSecondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 20.0),
              if (true) // Condition if you need an 'or' divider
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
                              color: _colorController
                                  .colorScheme.value.onSurface)),
                    ),
                    Expanded(
                      child: Divider(
                          thickness: 2,
                          color: _colorController.colorScheme.value.onSurface),
                    ),
                  ],
                ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account ? "),
                  TextButton(
                      onPressed: () {
                        Get.back(); // This will navigate back to the previous page
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: _colorController.colorScheme.value.primary,
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
