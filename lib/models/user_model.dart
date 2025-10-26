import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final List<String> enrolledCourses;
  final Map<String, dynamic> courseProgress;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
    this.enrolledCourses = const [],
    this.courseProgress = const {},
  });

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      // Optional: switch to FieldValue.serverTimestamp() if preferred
      'createdAt': createdAt.toIso8601String(),
      'enrolledCourses': enrolledCourses,
      'courseProgress': courseProgress,
    };
  }

  // Create UserModel from Firestore document safely
  factory UserModel.fromMap(Map<String, dynamic> map) {
    dynamic createdAtValue = map['createdAt'];

    DateTime parsedDate;
    if (createdAtValue is Timestamp) {
      parsedDate = createdAtValue.toDate();
    } else if (createdAtValue is String) {
      parsedDate = DateTime.tryParse(createdAtValue) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      createdAt: parsedDate,
      enrolledCourses: List<String>.from(map['enrolledCourses'] ?? []),
      courseProgress: Map<String, dynamic>.from(map['courseProgress'] ?? {}),
    );
  }

  // Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    DateTime? createdAt,
    List<String>? enrolledCourses,
    Map<String, dynamic>? courseProgress,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      courseProgress: courseProgress ?? this.courseProgress,
    );
  }
}
