// Model class to represent a Course in the app
class CourseModel {
  // Unique identifier for the course
  final String id;

  // Title or name of the course
  final String title;

  // Detailed description of the course content
  final String description;

  // Name of the instructor or trainer for the course
  final String instructor;

  // URL of the course image or thumbnail
  final String imageUrl;

  // List of topics covered in the course
  final List<String> topics;

  // Duration of the course in hours
  final int duration;

  // Level of difficulty (Beginner, Intermediate, Advanced)
  final String difficulty;

  // Average rating given by students
  final double rating;

  // Total number of students enrolled
  final int totalStudents;

  // Date and time when the course was created
  final DateTime createdAt;

  // Indicates if the course is currently active
  final bool isActive;

  // Indicates if the course is featured on the platform
  final bool isFeatured;

  // Constructor with required parameters and optional defaults
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
    this.isActive = true, // Default value true
    required this.isFeatured,
  });

  // Convert CourseModel object into a Map for storing in Firestore
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
      'createdAt': createdAt.toIso8601String(), // Store date as string
      'isActive': isActive,
      'isFeatured': isFeatured,
    };
  }

  // Factory constructor to create a CourseModel object from a Firestore Map
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

  // Create a modified copy of an existing CourseModel object
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
