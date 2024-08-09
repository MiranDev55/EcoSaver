import 'package:eco_saver/controllers/color_controller.dart';
import 'package:eco_saver/views/widgets/app_bar.dart';
import 'package:eco_saver/views/widgets/dashboard_widgets/budget_card.dart';
import 'package:eco_saver/views/widgets/dashboard_widgets/next_goal_card.dart';
import 'package:eco_saver/views/widgets/dashboard_widgets/total_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final ColorController colorController = Get.find<ColorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Dashboard",
      ),
      backgroundColor: colorController.colorScheme.value.surface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ToTalBalanceCard(), // total balance.
              NextGoalCard(), // basic bar analytics
              BudgetCard(),
            ],
          ),
        ),
      ),
    );
  }
}