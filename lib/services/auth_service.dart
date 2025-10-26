import 'package:firebase_auth/firebase_auth.dart';

/// Authentication service to manage user authentication state
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get the current user
  static User? get currentUser => _auth.currentUser;

  /// Check if user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;

  /// Get user ID
  static String? get userId => _auth.currentUser?.uid;

  /// Get user email
  static String? get userEmail => _auth.currentUser?.email;

  /// Get user display name
  static String? get userDisplayName => _auth.currentUser?.displayName;

  /// Stream of authentication state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign out the current user
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Sign in with email and password
  static Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Create user with email and password
  static Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Update user display name
  static Future<void> updateDisplayName(String displayName) async {
    if (_auth.currentUser != null) {
      await _auth.currentUser!.updateDisplayName(displayName);
    }
  }
}
