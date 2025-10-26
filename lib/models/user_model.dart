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
      'createdAt': createdAt.toIso8601String(),
      'enrolledCourses': enrolledCourses,
      'courseProgress': courseProgress,
    };
  }

  // Create UserModel from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
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
