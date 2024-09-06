import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  final String name; // The name of the budget (document ID)
  final double budget;
  final DateTime dateCreated;
  final DateTime dateModified;

  Budget({
    required this.name, // Include the name (document ID)
    required this.budget,
    required this.dateCreated,
    required this.dateModified,
  });

  // Convert a Firestore document into a Budget object
  factory Budget.fromFirestore(String documentId, Map<String, dynamic> data) {
    return Budget(
      name: documentId, // Document ID becomes the name of the budget
      budget: data['budget'],
      dateCreated: (data['dateCreated'] as Timestamp).toDate(),
      dateModified: (data['dateModified'] as Timestamp).toDate(),
    );
  }

  // Convert a Budget object into a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'budget': budget,
      'dateCreated': dateCreated,
      'dateModified': dateModified,
    };
  }
}
