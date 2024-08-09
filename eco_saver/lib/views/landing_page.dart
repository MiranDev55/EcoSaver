import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/controllers/landing_page_controller.dart';
import 'package:eco_saver/views/pages/analytics_page.dart';
import 'package:eco_saver/views/pages/categories_page.dart';
import 'package:eco_saver/views/pages/dashboard_page.dart';
import 'package:eco_saver/views/pages/goal_page.dart';
import 'package:eco_saver/views/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPage extends StatelessWidget {
  final ColorController _colorController = Get.find<ColorController>();

  TextStyle unselectedLabelStyle() => TextStyle(
      color: _colorController.colorScheme.value.onSurface,
      fontWeight: FontWeight.w500,
      fontSize: 12);

  TextStyle selectedLabelStyle() => TextStyle(
      color: _colorController.colorScheme.value.onPrimary,
      fontWeight: FontWeight.w500,
      fontSize: 14);

  LandingPage({super.key});

  Obx buildBottomNavigationMenu(
      context, LandingPageController landingPageController) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: BottomNavigationBar(
          onTap: landingPageController.changeTabIndex,
          currentIndex: landingPageController.tabIndex.value,
          selectedItemColor:
              _colorController.colorScheme.value.secondary, // working
          unselectedItemColor:
              _colorController.colorScheme.value.primary, // working
          unselectedLabelStyle: unselectedLabelStyle(),
          selectedLabelStyle: selectedLabelStyle(),
          items: [
            BottomNavigationBarItem(
              backgroundColor: _colorController.colorScheme.value.surface,
              icon: const Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              backgroundColor: _colorController.colorScheme.value.surface,
              icon: const Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              backgroundColor: _colorController.colorScheme.value.surface,
              icon: const Icon(Icons.analytics),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              backgroundColor: _colorController.colorScheme.value.surface,
              icon: const Icon(Icons.swap_horiz),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              backgroundColor: _colorController.colorScheme.value.surface,
              icon: const Icon(Icons.golf_course_sharp),
              label: 'Goals',
            ),
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    final LandingPageController landingPageController =
        Get.put(LandingPageController(), permanent: false);
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar:
          buildBottomNavigationMenu(context, landingPageController),
      body: Obx(() => IndexedStack(
            index: landingPageController.tabIndex.value,
            children: [
              DashboardPage(),
              CategoriesPage(),
              AnalyticsPage(),
              TransactionPage(),
              GoalPage(),
            ],
          )),
    ));
  }
}
