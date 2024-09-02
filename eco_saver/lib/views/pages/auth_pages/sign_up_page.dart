import 'dart:io';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/controllers/signup_controller.dart';
import 'package:eco_saver/services/auth_service.dart';
import 'package:eco_saver/utils/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignupPage extends StatelessWidget {
  final AuthService authController = Get.find<AuthService>();
  final ColorController _colorController = Get.find<ColorController>();
  final SignupController signupController = Get.put(SignupController());

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
                    Text(
                      'Create Account',
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
              Center(
                child: GestureDetector(
                  onTap: () => _showImagePickerOptions(context),
                  child: Obx(() => CircleAvatar(
                        radius: 50,
                        backgroundImage: signupController
                                .selectedImagePath.value.isNotEmpty
                            ? FileImage(
                                File(signupController.selectedImagePath.value))
                            : null,
                        child: signupController.selectedImagePath.value.isEmpty
                            ? const Icon(Icons.add_a_photo, size: 50)
                            : null,
                      )),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: signupController.emailController,
                decoration: customInputDecoration(
                  labelText: 'Your email address',
                  borderColor: _colorController.colorScheme.value.onSecondary,
                  focusedBorderColor:
                      _colorController.colorScheme.value.secondary,
                  focusedLabelColor:
                      _colorController.colorScheme.value.onSecondary,
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: signupController.passwordController,
                obscureText: true,
                decoration: customInputDecoration(
                  labelText: 'Choose a password',
                  borderColor: _colorController.colorScheme.value.onSecondary,
                  focusedBorderColor:
                      _colorController.colorScheme.value.secondary,
                  focusedLabelColor:
                      _colorController.colorScheme.value.onSecondary,
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: signupController.nameController,
                decoration: customInputDecoration(
                  labelText: 'Your name',
                  borderColor: _colorController.colorScheme.value.onSecondary,
                  focusedBorderColor:
                      _colorController.colorScheme.value.secondary,
                  focusedLabelColor:
                      _colorController.colorScheme.value.onSecondary,
                ),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () async {
                  String profileImagePath =
                      signupController.selectedImagePath.value;

                  Map<String, dynamic> userDetails = {
                    'email': signupController.emailController.text,
                    'name': signupController.nameController.text,
                    'createdAt': DateTime.now(),
                    'profileImage':
                        profileImagePath.isNotEmpty ? profileImagePath : "",
                  };

                  await authController
                      .createUser(
                    signupController.emailController.text,
                    signupController.passwordController.text,
                    userDetails,
                  )
                      .then((_) {
                    if (authController.isLoggedIn()) {
                      Get.offNamed(
                          '/landing'); // Navigate to landing page after signup
                    }
                  });
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  TextButton(
                      onPressed: () {
                        Get.back();
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

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    signupController.pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  signupController.pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
