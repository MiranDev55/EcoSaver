import 'package:eco_saver/controllers/buttons_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/views/pages/auth_pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eco_saver/firebase_options.dart';
import 'package:eco_saver/services/auth_service.dart';
import 'package:eco_saver/views/pages/splash_screen.dart';
import 'package:eco_saver/views/pages/auth_pages/login_page.dart';
import 'package:eco_saver/views/landing_page.dart';
import 'package:eco_saver/utils/landing_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put<ColorController>(ColorController());
  // Initialize global AuthService
  Get.put<AuthService>(AuthService());

  Get.put<ButtonsController>(ButtonsController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ColorController _colorController = Get.find<ColorController>();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor:
              _colorController.colorScheme.value.primary, // Cursor color
          //selectionColor: Colors.yellow, // Highlighted text color
          selectionHandleColor: _colorController
              .colorScheme.value.primary, // Handle (bubble) color
        ),
      ),
      getPages: [
        // Splash screen route
        GetPage(
          name: '/',
          page: () => SplashScreen(),
        ),
        // Landing page route, controllers only initialized if logged in
        GetPage(
          name: '/landing',
          page: () => LandingPage(),
          binding: LandingBinding(),
        ),
        // Login and signup routes
        GetPage(
          name: '/login',
          page: () => LoginPage(),
        ),
        GetPage(
          name: '/signup',
          page: () => SignupPage(),
        ),
      ],
    );
  }
}
