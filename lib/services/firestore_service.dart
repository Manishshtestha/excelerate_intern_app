import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/course_model.dart';

// FirestoreService handles all Firestore database operations for users and courses.
class FirestoreService {
  // Instance of Firestore used to perform database operations
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection names
  static const String _usersCollection = 'users';
  static const String _coursesCollection = 'courses';

  // Method to test Firestore connection
  static Future<bool> testConnection() async {
    try {
      await _firestore.collection('test').doc('test').get();
      return true;
    } catch (e) {
      print('Firestore connection test failed: $e');
      return false;
    }
  }

  // Create a new user document in Firestore
  static Future<void> createUser(UserModel user) async {
    try {
      print('Creating user with UID: ${user.uid}');
      print('User data: ${user.toMap()}');

      // Save user data using UID as document ID
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

  // Fetch a user document from Firestore by UID
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

  // Update an existing user document
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

  // Enroll a user in a course by adding course ID to user's enrolledCourses list
  static Future<void> enrollInCourse(String userId, String courseId) async {
    try {
      final userDoc = _firestore.collection(_usersCollection).doc(userId);

      // Transaction ensures data consistency
      await _firestore.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userDoc);

        if (userSnapshot.exists) {
          final userData = userSnapshot.data()!;
          final enrolledCourses = List<String>.from(
            userData['enrolledCourses'] ?? [],
          );

          // Add course only if not already enrolled
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

  // Update a user's progress for a specific course
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

          // Update progress value for the course
          courseProgress[courseId] = progress;
          transaction.update(userDoc, {'courseProgress': courseProgress});
        }
      });
    } catch (e) {
      throw Exception('Failed to update course progress: $e');
    }
  }

  // Create a new course document in Firestore
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

  // Retrieve all active courses from Firestore
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

  // Retrieve a single course by course ID
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

  // Retrieve all courses a user is enrolled in
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

      // Fetch all courses where ID matches user's enrolled courses
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

  // Real-time stream for listening to changes in a user's data
  static Stream<UserModel?> getUserStream(String uid) {
    return _firestore.collection(_usersCollection).doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    });
  }

  // Real-time stream for listening to changes in all active courses
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
}
