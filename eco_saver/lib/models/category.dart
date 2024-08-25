import 'package:eco_saver/utils/category_type.dart';
import 'package:flutter/material.dart';

class Category {
  final String name;
  final CategoryType type;
  final IconData icon;

  Category({
    required this.name,
    required this.type,
    required this.icon, // Icon field
  });
}
