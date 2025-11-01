import 'package:firebase_auth/firebase_auth.dart';

/// AuthService manages user authentication using Firebase Authentication.
/// It includes sign-in, sign-up, sign-out, and user state tracking methods.
class AuthService {
  // FirebaseAuth instance for handling authentication operations
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Returns the currently signed-in user, if any.
  static User? get currentUser => _auth.currentUser;

  /// Checks if a user is currently logged in.
  static bool get isLoggedIn => _auth.currentUser != null;

  /// Returns the UID (unique identifier) of the logged-in user.
  static String? get userId => _auth.currentUser?.uid;

  /// Returns the email of the logged-in user.
  static String? get userEmail => _auth.currentUser?.email;

  /// Returns the display name of the logged-in user.
  static String? get userDisplayName => _auth.currentUser?.displayName;

  /// Provides a real-time stream that listens to changes in authentication state.
  /// This helps detect when a user logs in or out.
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Signs out the current user.
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Signs in an existing user using email and password.
  /// Returns a [UserCredential] object upon successful authentication.
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
      rethrow; // Propagates error to be handled at the UI level
    }
  }

  /// Creates a new user account using email and password.
  /// Returns a [UserCredential] upon successful registration.
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

  /// Updates the current user's display name.
  /// This is typically used after registration or profile editing.
  static Future<void> updateDisplayName(String displayName) async {
    if (_auth.currentUser != null) {
      await _auth.currentUser!.updateDisplayName(displayName);
    }
  }
}
