import 'package:eco_saver/controllers/color_controller.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  ExpenseList({super.key, required this.colorController});

  final ColorController colorController;
  final List<Map<String, dynamic>> expenses = [
    {
      'date': 'November 08',
      'category': 'Educations',
      'amount': '\$89.05',
    },
    {
      'date': 'November 07',
      'category': 'Lunch',
      'amount': '\$10.11',
    },
  ];

  TextStyle _textStyle(Color color, FontWeight fontWeight, double opacity,
          {double fontSize = 14}) =>
      TextStyle(
          color: color.withOpacity(opacity),
          fontWeight: fontWeight,
          fontSize: fontSize);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  color: colorController.colorScheme.value.secondary,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      expenses[index]["date"],
                      style: _textStyle(
                          colorController.colorScheme.value.onSecondary,
                          FontWeight.bold,
                          0.5),
                    ),
                    Text(
                      expenses[index]["amount"],
                      style: _textStyle(
                          colorController.colorScheme.value.primary,
                          FontWeight.bold,
                          1,
                          fontSize: 16),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                  color: colorController.colorScheme.value.surface,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          expenses[index]["category"],
                          style: _textStyle(
                            colorController.colorScheme.value.primary,
                            FontWeight.bold,
                            1,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          expenses[index]["category"],
                          style: _textStyle(
                            colorController.colorScheme.value.primary,
                            FontWeight.normal,
                            1,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      expenses[index]["amount"],
                      style: _textStyle(
                        colorController.colorScheme.value.onSecondary,
                        FontWeight.bold,
                        0.5,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
