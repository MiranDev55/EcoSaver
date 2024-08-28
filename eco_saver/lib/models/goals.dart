import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  String id;
  String goalName;
  double targetAmount;
  double amountSaved;
  DateTime createdAt;
  String? notes;
  String? priority;
  String status;

  Goal({
    required this.id,
    required this.goalName,
    required this.targetAmount,
    this.amountSaved = 0.0,
    required this.createdAt,
    this.notes,
    this.priority,
    this.status = "Active",
  });

  // Factory constructor to create a Goal object from a Firestore document
  factory Goal.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Goal(
      id: doc.id,
      goalName: data['goalName'],
      targetAmount: data['targetAmount'],
      amountSaved: data['amountSaved'] ?? 0.0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      notes: data['notes'],
      priority: data['priority'],
      status: data['status'],
    );
  }

  // Method to convert a Goal object to a Map, for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'goalName': goalName,
      'targetAmount': targetAmount,
      'amountSaved': amountSaved,
      'createdAt': createdAt,
      'notes': notes,
      'priority': priority,
      'status': status,
    };
  }
}
