import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String userId;
  double amount;
  String category;
  DateTime date;
  String? notes;
  DateTime createdAt;

  Expense({
    required this.userId,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      userId: json['userId'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date:
          (json['date'] as Timestamp).toDate(), // Convert Timestamp to DateTime
      notes: json['notes'],
      createdAt: (json['createdAt'] as Timestamp)
          .toDate(), // Convert Timestamp to DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date), // Convert DateTime to Timestamp
      'notes': notes,
      'createdAt':
          Timestamp.fromDate(createdAt), // Convert DateTime to Timestamp
    };
  }
}
