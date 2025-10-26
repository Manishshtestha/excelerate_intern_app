import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/course_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  static const String _usersCollection = 'users';
  static const String _coursesCollection = 'courses';

  // Test Firestore connection
  static Future<bool> testConnection() async {
    try {
      await _firestore.collection('test').doc('test').get();
      return true;
    } catch (e) {
      print('Firestore connection test failed: $e');
      return false;
    }
  }

  // User operations
  static Future<void> createUser(UserModel user) async {
    try {
      print('Creating user with UID: ${user.uid}');
      print('User data: ${user.toMap()}');

      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(user.toMap());

      print('User created successfully in Firestore');
    } catch (e) {
      print('Error creating user in Firestore: $e');
      throw Exception('Failed to create user: $e');
    }
  }

  static Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  static Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  static Future<void> enrollInCourse(String userId, String courseId) async {
    try {
      final userDoc = _firestore.collection(_usersCollection).doc(userId);

      await _firestore.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userDoc);

        if (userSnapshot.exists) {
          final userData = userSnapshot.data()!;
          final enrolledCourses = List<String>.from(
            userData['enrolledCourses'] ?? [],
          );

          if (!enrolledCourses.contains(courseId)) {
            enrolledCourses.add(courseId);
            transaction.update(userDoc, {'enrolledCourses': enrolledCourses});
          }
        }
      });
    } catch (e) {
      throw Exception('Failed to enroll in course: $e');
    }
  }

  static Future<void> updateCourseProgress(
    String userId,
    String courseId,
    double progress,
  ) async {
    try {
      final userDoc = _firestore.collection(_usersCollection).doc(userId);

      await _firestore.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userDoc);

        if (userSnapshot.exists) {
          final userData = userSnapshot.data()!;
          final courseProgress = Map<String, dynamic>.from(
            userData['courseProgress'] ?? {},
          );
          courseProgress[courseId] = progress;

          transaction.update(userDoc, {'courseProgress': courseProgress});
        }
      });
    } catch (e) {
      throw Exception('Failed to update course progress: $e');
    }
  }

  // Course operations
  static Future<void> createCourse(CourseModel course) async {
    try {
      await _firestore
          .collection(_coursesCollection)
          .doc(course.id)
          .set(course.toMap());
    } catch (e) {
      throw Exception('Failed to create course: $e');
    }
  }

  static Future<List<CourseModel>> getAllCourses() async {
    try {
      final querySnapshot = await _firestore
          .collection(_coursesCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CourseModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get courses: $e');
    }
  }

  static Future<CourseModel?> getCourse(String courseId) async {
    try {
      final doc = await _firestore
          .collection(_coursesCollection)
          .doc(courseId)
          .get();

      if (doc.exists) {
        return CourseModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get course: $e');
    }
  }

  static Future<List<CourseModel>> getUserEnrolledCourses(String userId) async {
    try {
      final userDoc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();

      if (!userDoc.exists) return [];

      final userData = userDoc.data()!;
      final enrolledCourseIds = List<String>.from(
        userData['enrolledCourses'] ?? [],
      );

      if (enrolledCourseIds.isEmpty) return [];

      final querySnapshot = await _firestore
          .collection(_coursesCollection)
          .where(FieldPath.documentId, whereIn: enrolledCourseIds)
          .get();

      return querySnapshot.docs
          .map((doc) => CourseModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user enrolled courses: $e');
    }
  }

  // Stream operations for real-time updates
  static Stream<UserModel?> getUserStream(String uid) {
    return _firestore.collection(_usersCollection).doc(uid).snapshots().map((
      doc,
    ) {
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    });
  }

  static Stream<List<CourseModel>> getCoursesStream() {
    return _firestore
        .collection(_coursesCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs
              .map((doc) => CourseModel.fromMap(doc.data()))
              .toList();
        });
  }

  // Initialize sample data
  static Future<void> initializeSampleData() async {
    try {
      print('Initializing sample data...');

      // Check if courses already exist
      final coursesSnapshot = await _firestore
          .collection(_coursesCollection)
          .get();

      print('Found ${coursesSnapshot.docs.length} existing courses');

      if (coursesSnapshot.docs.isEmpty) {
        print('Creating sample courses...');
        // Create sample courses
        final sampleCourses = [
          CourseModel(
            id: 'flutter_basics',
            title: 'Flutter Basics',
            description: 'Learn the fundamentals of Flutter development',
            instructor: 'John Doe',
            imageUrl: 'https://via.placeholder.com/300x200',
            topics: [
              'Widgets',
              'State Management',
              'Navigation',
              'API Integration',
            ],
            duration: 20,
            difficulty: 'Beginner',
            rating: 4.5,
            totalStudents: 150,
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
          CourseModel(
            id: 'dart_fundamentals',
            title: 'Dart Fundamentals',
            description: 'Master the Dart programming language',
            instructor: 'Jane Smith',
            imageUrl: 'https://via.placeholder.com/300x200',
            topics: ['Variables', 'Functions', 'Classes', 'Async Programming'],
            duration: 15,
            difficulty: 'Beginner',
            rating: 4.3,
            totalStudents: 120,
            createdAt: DateTime.now().subtract(const Duration(days: 25)),
          ),
          CourseModel(
            id: 'python_basics',
            title: 'Python Basics',
            description: 'Introduction to Python programming',
            instructor: 'Mike Johnson',
            imageUrl: 'https://via.placeholder.com/300x200',
            topics: ['Syntax', 'Data Types', 'Control Flow', 'Functions'],
            duration: 25,
            difficulty: 'Beginner',
            rating: 4.7,
            totalStudents: 200,
            createdAt: DateTime.now().subtract(const Duration(days: 20)),
          ),
          CourseModel(
            id: 'node_essentials',
            title: 'Node.js Essentials',
            description: 'Build server-side applications with Node.js',
            instructor: 'Sarah Wilson',
            imageUrl: 'https://via.placeholder.com/300x200',
            topics: ['Modules', 'Express.js', 'Database Integration', 'APIs'],
            duration: 30,
            difficulty: 'Intermediate',
            rating: 4.4,
            totalStudents: 180,
            createdAt: DateTime.now().subtract(const Duration(days: 15)),
          ),
        ];

        // Add courses to Firestore
        for (final course in sampleCourses) {
          await createCourse(course);
        }
        print('Sample courses created successfully');
      } else {
        print('Sample courses already exist, skipping creation');
      }
    } catch (e) {
      print('Error initializing sample data: $e');
      throw Exception('Failed to initialize sample data: $e');
    }
  }
}
