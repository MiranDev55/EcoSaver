import 'package:eco_saver/models/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eco_saver/utils/category_type.dart'; // Import the CategoryType enum

class CategoryController extends GetxController {
  var expenseCategories = <Category>[].obs;
  var incomeCategories = <Category>[].obs;
  var pieChartTouchedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize expense categories
    expenseCategories.addAll([
      Category(
          name: "Business", type: CategoryType.expense, icon: Icons.business),
      Category(
          name: "Car", type: CategoryType.expense, icon: Icons.directions_car),
      Category(
          name: "Eat at Home",
          type: CategoryType.expense,
          icon: Icons.restaurant),
      Category(
          name: "Education", type: CategoryType.expense, icon: Icons.school),
      Category(name: "Home Pets", type: CategoryType.expense, icon: Icons.pets),
      Category(
          name: "Entertainment", type: CategoryType.expense, icon: Icons.movie),
      Category(
          name: "Groceries",
          type: CategoryType.expense,
          icon: Icons.shopping_cart),
      Category(
          name: "Health",
          type: CategoryType.expense,
          icon: Icons.local_hospital),
      Category(
          name: "Transportation",
          type: CategoryType.expense,
          icon: Icons.train),
      Category(
          name: "Utilities", type: CategoryType.expense, icon: Icons.build),
      Category(
          name: "Travel",
          type: CategoryType.expense,
          icon: Icons.airplanemode_active),
      Category(
          name: "Miscellaneous",
          type: CategoryType.expense,
          icon: Icons.more_horiz),
    ]);

    // Initialize income categories
    incomeCategories.addAll([
      Category(
          name: "Salary", type: CategoryType.income, icon: Icons.attach_money),
      Category(
          name: "Freelancing", type: CategoryType.income, icon: Icons.work),
      Category(
          name: "Investments",
          type: CategoryType.income,
          icon: Icons.show_chart),
      Category(
          name: "Gifts", type: CategoryType.income, icon: Icons.card_giftcard),
      Category(
          name: "Rental Income", type: CategoryType.income, icon: Icons.home),
      Category(
          name: "Dividends",
          type: CategoryType.income,
          icon: Icons.account_balance),
      Category(
          name: "Interest", type: CategoryType.income, icon: Icons.percent),
      Category(
          name: "Sales", type: CategoryType.income, icon: Icons.shopping_bag),
      Category(
          name: "Miscellaneous",
          type: CategoryType.income,
          icon: Icons.more_horiz),
    ]);
  }

  // Method to add a new category
  void addCategory(Category category) {
    if (category.type == CategoryType.expense) {
      expenseCategories.add(category);
    } else if (category.type == CategoryType.income) {
      incomeCategories.add(category);
    }
  }

  // Method to remove a category (for completeness)
  void removeCategory(Category category) {
    if (category.type == CategoryType.expense) {
      expenseCategories.remove(category);
    } else if (category.type == CategoryType.income) {
      incomeCategories.remove(category);
    }
  }

  void updatePieChartTouchedIndex(int index) {
    pieChartTouchedIndex.value = index;
  }
}
