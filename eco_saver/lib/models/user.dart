import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  String username;
  String profilePic;
  DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.profilePic = '',
    this.createdAt,
  });

  // Factory method to create a UserModel from Firestore data
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      profilePic: data['profilePic'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)
          ?.toDate(), // Convert Firestore Timestamp to DateTime
    );
  }

  // Method to convert UserModel to a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'profilePic': profilePic,
      'createdAt':
          FieldValue.serverTimestamp(), // Use server timestamp for createdAt
    };
  }
}
