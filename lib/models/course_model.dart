class CourseModel {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String imageUrl;
  final List<String> topics;
  final int duration; // in hours
  final String difficulty; // Beginner, Intermediate, Advanced
  final double rating;
  final int totalStudents;
  final DateTime createdAt;
  final bool isActive;
  final bool isFeatured;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.imageUrl,
    required this.topics,
    required this.duration,
    required this.difficulty,
    required this.rating,
    required this.totalStudents,
    required this.createdAt,
    this.isActive = true,
    required this.isFeatured,
  });

  // Convert CourseModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'imageUrl': imageUrl,
      'topics': topics,
      'duration': duration,
      'difficulty': difficulty,
      'rating': rating,
      'totalStudents': totalStudents,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'isFeatured': isFeatured,
    };
  }

  // Create CourseModel from Firestore document
  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      instructor: map['instructor'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      topics: List<String>.from(map['topics'] ?? []),
      duration: map['duration'] ?? 0,
      difficulty: map['difficulty'] ?? 'Beginner',
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalStudents: map['totalStudents'] ?? 0,
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      isActive: map['isActive'] ?? true,
      isFeatured: map['isFeatured'] ?? false,
    );
  }

  // Create a copy of CourseModel with updated fields
  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? instructor,
    String? imageUrl,
    List<String>? topics,
    int? duration,
    String? difficulty,
    double? rating,
    int? totalStudents,
    DateTime? createdAt,
    bool? isActive,
    bool? isFeatured,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      instructor: instructor ?? this.instructor,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      rating: rating ?? this.rating,
      totalStudents: totalStudents ?? this.totalStudents,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}
