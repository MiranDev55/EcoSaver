import 'package:eco_saver/services/auth_service.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eco_saver/views/widgets/setting_sections.dart';

class SettingsScreen extends StatelessWidget {
  final ColorController colorController = Get.find();
  final AuthService authService = Get.find();

  SettingsScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout,
                size: 48,
                color: colorController.colorScheme.value.secondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: colorController.colorScheme.value.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to log out?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorController.colorScheme.value.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      'No, Keep Logged In',
                      style: TextStyle(
                        color: colorController.colorScheme.value.primary,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.signOut().then((_) {
                        // Navigate to login page after successful logout
                        Get.offAllNamed('/login');
                        authService.disposeUserDependentControllers().then((_) {
                          authService.clearUserData();
                        });
                      }); // Log out the user
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          colorController.colorScheme.value.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Yes, Log Out',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorController.colorScheme.value.surface,
      appBar: AppBar(
        backgroundColor: colorController.colorScheme.value.surface,
        title: Text(
          'Settings',
          style: TextStyle(color: colorController.colorScheme.value.primary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: colorController.colorScheme.value.onPrimary,
              child: Column(
                children: [
                  const SectionTitle(title: 'GENERAL'),
                  MenuItem(
                    icon: Icons.person,
                    title: 'Account',
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                  MenuItem(
                    icon: Icons.delete,
                    title: 'Delete account',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              color: colorController.colorScheme.value.onPrimary,
              child: Column(
                children: [
                  const SectionTitle(title: 'FEEDBACK'),
                  MenuItem(
                    icon: Icons.bug_report,
                    title: 'Report a bug',
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: Icons.feedback,
                    title: 'Send feedback',
                    onTap: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
