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
}
  