import 'package:eco_saver/auth_binding.dart';
import 'package:eco_saver/controllers/buttons_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/services/auth_service.dart';
import 'package:eco_saver/views/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/pages/auth_pages/login_page.dart';
import 'views/pages/auth_pages/sign_up_page.dart';
import 'views/landing_page.dart';
import 'firebase_options.dart';

void main() async {
  print("this is a test");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize global controllers
  Get.put(AuthService());
  Get.put(ColorController());
  Get.put(ButtonsController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(
            name: '/landing',
            page: () => LandingPage(),
            binding: AuthBinding()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignupPage()),
      ],
    );
  }
}


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   final AuthService authService = Get.put(AuthService());

//   // These controllers can be initialized immediately
//   Get.put(ColorController());
//   Get.put(ButtonsController());

//   runApp(MyApp(
//     initialRoute: authService.isLoggedIn() ? '/landing' : '/login',
//   ));
// }

// class MyApp extends StatelessWidget {
//   final String initialRoute;
//   const MyApp({super.key, required this.initialRoute});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       initialRoute: initialRoute,
//       debugShowCheckedModeBanner: false,
//       getPages: [
//         GetPage(
//           name: '/landing',
//           page: () => LandingPage(),
//           binding: AuthBinding(),
//         ),
//         GetPage(name: '/login', page: () => LoginPage()),
//         GetPage(name: '/signup', page: () => SignupPage()),
//       ],
//     );
//   }
// }
