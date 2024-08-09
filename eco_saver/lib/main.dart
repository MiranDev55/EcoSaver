// main.dart
import 'package:eco_saver/controllers/buttons_controller.dart';
import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/views/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(ColorController()); // Initialize the ColorController globally
  Get.put(ButtonsController());

  runApp(const MainApp());
}

class MainApp extends GetMaterialApp {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}
