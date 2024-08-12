import 'package:eco_saver/controllers/buttons_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/services/expenses_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart'; // Ensure this is correctly imported
import 'views/pages/auth_pages/login_page.dart';
import 'views/pages/auth_pages/sign_up_page.dart';
import 'views/landing_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize GetX controllers
  Get.put(ColorController());
  Get.put(ButtonsController());

  Get.put(ExpenseController());

  final AuthController authController = Get.put(AuthController());

  runApp(MyApp(
    initialRoute: authController.isLoggedIn() ? '/landing' : '/login',
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eco Saver',
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignupPage()),
        GetPage(name: '/landing', page: () => LandingPage()),
      ],
    );
  }
}
