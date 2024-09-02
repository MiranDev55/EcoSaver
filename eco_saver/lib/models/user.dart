import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String profileImageUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.profileImageUrl,
  });

  // Factory constructor to create a UserModel from a Firestore document snapshot
  factory UserModel.fromjson(DocumentSnapshot doc) {
    return UserModel(
      uid: doc.id,
      email: doc['email'],
      name: doc['name'],
      profileImageUrl: doc['profileImage'] ?? '',
    );
  }

  // Convert UserModel to a Map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profileImage': profileImageUrl,
    };
  }
}
