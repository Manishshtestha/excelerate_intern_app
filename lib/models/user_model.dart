import 'package:cloud_firestore/cloud_firestore.dart';

// Model class representing a User in the system
class UserModel {
  // Unique user ID from Firebase Authentication
  final String uid;

  // User's registered email address
  final String email;

  // User's display name or username
  final String displayName;

  // The date and time when the user account was created
  final DateTime createdAt;

  // List of course IDs that the user has enrolled in
  final List<String> enrolledCourses;

  // Map to store progress data for each enrolled course (e.g., courseID: progressPercentage)
  final Map<String, dynamic> courseProgress;

  // Constructor to initialize all user fields
  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
    this.enrolledCourses = const [], // Default empty list if none provided
    this.courseProgress = const {}, // Default empty map if none provided
  });

  // Convert UserModel into a Map format for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      // Stores the creation date as an ISO 8601 string (optional: could use serverTimestamp)
      'createdAt': createdAt.toIso8601String(),
      'enrolledCourses': enrolledCourses,
      'courseProgress': courseProgress,
    };
  }

  // Factory constructor to safely create a UserModel from Firestore data
  factory UserModel.fromMap(Map<String, dynamic> map) {
    dynamic createdAtValue = map['createdAt'];

    // Handle multiple possible types for createdAt (Timestamp or String)
    DateTime parsedDate;
    if (createdAtValue is Timestamp) {
      parsedDate = createdAtValue.toDate(); // Firestore Timestamp
    } else if (createdAtValue is String) {
      parsedDate = DateTime.tryParse(createdAtValue) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now(); // Default fallback
    }

    // Return a fully initialized UserModel object
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      createdAt: parsedDate,
      enrolledCourses: List<String>.from(map['enrolledCourses'] ?? []),
      courseProgress: Map<String, dynamic>.from(map['courseProgress'] ?? {}),
    );
  }

  // Create a modified copy of the current UserModel instance
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
