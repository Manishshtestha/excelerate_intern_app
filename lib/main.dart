import 'package:excelerate_intern_app/pages/bottom_nav.dart';
import 'package:excelerate_intern_app/pages/catalog_page.dart';
import 'package:excelerate_intern_app/pages/login.dart';
import 'package:excelerate_intern_app/pages/profile_page.dart';
import 'package:excelerate_intern_app/pages/progress_page.dart';
import 'package:excelerate_intern_app/pages/register.dart';
import 'package:excelerate_intern_app/pages/splash_screen.dart';
import 'package:excelerate_intern_app/pages/CourseDetailPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Theme/app_theme.dart';

/// Entry point of the Flutter application.
/// Ensures Firebase is initialized before the app starts.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter engine is ready
  await Firebase.initializeApp(); // Initializes Firebase for authentication and database access
  runApp(const MyApp()); // Launches the root widget of the app
}

/// Root widget of the application.
/// Defines theme, routes, and initial navigation flow.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Defines the global theme for the app
      theme: AppTheme.lightTheme,

      // Initial screen displayed on app launch
      home: const AuthWrapper(),

      // Removes the debug banner (visible during development)
      debugShowCheckedModeBanner: false,

      // Defines all named routes used throughout the app
      routes: {
        '/login': (context) => const LoginPage(), // Login screen
        '/register': (context) => const RegisterPage(), // Registration screen
        '/bottomnav': (context) => const BottomNav(), // Main navigation screen
        '/catalog': (context) => const CatalogPage(), // Course catalog
        '/progress': (context) => const ProgressPage(), // Progress tracking page
        '/profile': (context) => const ProfilePage(), // User profile page

        // Course detail page with arguments passed via Navigator
        '/course-detail': (context) {
          final course =
              ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return CourseDetailPage(course: course ?? {});
        },
      },
    );
  }
}

/// A wrapper widget that decides which screen to display
/// based on user authentication state.
///
/// - Shows splash screen for a fixed duration.
/// - Checks Firebase authentication status.
/// - Redirects to appropriate screen:
///   - `BottomNav` if user is logged in.
///   - `LoginPage` if user is logged out.
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isSplashComplete = false; // Tracks if splash screen duration is completed

  @override
  void initState() {
    super.initState();

    // Display splash screen for 6 seconds before checking auth state
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _isSplashComplete = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // If splash screen duration not complete, show splash screen
    if (!_isSplashComplete) {
      return const SplashScreen();
    }

    // Listen to Firebase authentication state changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While checking authentication, show splash screen
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // Display error screen if authentication check fails
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Authentication Error',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString(), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Redirect user to login screen in case of error
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Go to Login'),
                  ),
                ],
              ),
            ),
          );
        }

        // If user is logged in, navigate to the main app screen
        if (snapshot.hasData && snapshot.data != null) {
          return const BottomNav();
        }

        // If no user is logged in, show login screen
        return const LoginPage();
      },
    );
  }
}
