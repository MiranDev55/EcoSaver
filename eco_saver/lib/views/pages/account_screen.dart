import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/services/auth_service.dart';
import 'package:eco_saver/utils/custom_container.dart';
import 'package:eco_saver/views/widgets/appbar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountScreen extends StatelessWidget {
  final AuthService _authService = Get.find<AuthService>();
  final ColorController _colorController = Get.find<ColorController>();

  AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(title: "My Account"),
      backgroundColor: _colorController.colorScheme.value.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Picture Section
            CustomContainer(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor:
                        _colorController.colorScheme.value.secondary,
                    // backgroundImage: NetworkImage(_authService
                    //         .userModel.value?.profileImageUrl ??
                    //     'https://via.placeholder.com/150'), // Placeholder if no photo
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Logic to change the profile photo
                    },
                    child: Text(
                      'Edit photo',
                      style: TextStyle(
                        color: _colorController.colorScheme.value.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          color: _colorController.colorScheme.value.onSurface,
                        ),
                      ),
                      Text(
                        _authService.userModel.value?.name ??
                            'Name not available',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _colorController
                              .colorScheme.value.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'E-mail',
                        style: TextStyle(
                          color: _colorController.colorScheme.value.onSurface,
                        ),
                      ),
                      Text(
                        _authService.userModel.value?.email ??
                            'Email not available',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _colorController
                              .colorScheme.value.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            TextButton(
              onPressed: () {
                // Logic to change the password
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Change Password',
                    style: TextStyle(
                      decoration: TextDecoration.underline, // Adds underline
                      color: _colorController.colorScheme.value.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
