import 'package:eco_saver/models/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  var categories = <Category>[
    Category(name: "Business", color: Colors.blue),
    Category(name: "Car", color: Colors.green),
    Category(name: "Eat at home", color: Colors.red),
    Category(name: "Education", color: Colors.orange),
    Category(name: "Home Pets", color: Colors.purple),
  ].obs;

  var pieChartTouchedIndex = (-1).obs;

  void updatePieChartTouchedIndex(int index) {
    pieChartTouchedIndex.value = index;
  }
}
