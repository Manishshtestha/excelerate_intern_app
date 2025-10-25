import 'package:excelerate_intern_app/pages/bottom_nav.dart';
import 'package:excelerate_intern_app/pages/catalog_page.dart';
import 'package:excelerate_intern_app/pages/feedback_page.dart';
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

// The entry point of the Flutter app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme, // The theme for the app,
      // The first screen shown when the app starts
      home: const AuthWrapper(),

      // Removes the debug banner from the top-right corner
      debugShowCheckedModeBanner: false,

      // Defines all named routes for easy navigation throughout the app
      routes: {
        '/login': (context) => const LoginPage(), // Login screen route
        '/register': (context) =>
            const RegisterPage(), // Registration screen route
        '/bottomnav': (context) =>
            const BottomNav(), // Main bottom navigation screen
        '/catalog': (context) =>
            const CatalogPage(), // Course catalog or list screen
        '/progress': (context) =>
            const ProgressPage(), // User progress tracking page
        '/profile': (context) => const ProfilePage(), // User profile screen
        '/feedback': (context) =>
            const FeedbackScreen(), // (Optional) Feedback page if added later
        '/course-detail': (context) {
          final course =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return CourseDetailPage(course: course ?? {}); // Course detail page
        },
      },
    );
  }
}

// Wrapper widget to handle authentication state
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isSplashComplete = false;

  @override
  void initState() {
    super.initState();

    // Show splash screen for a fixed duration (e.g., 2 seconds)
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
    // Show splash screen for a fixed duration, then move to auth state check
    if (!_isSplashComplete) {
      return const SplashScreen(); // Show splash screen for 2 seconds
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show splash screen while checking authentication
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen(); // Splash during auth check
        }

        // Handle errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Authentication Error'),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString()),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Restart the app or handle error
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Go to Login'),
                  ),
                ],
              ),
            ),
          );
        }

        // If user is logged in, show main app
        if (snapshot.hasData && snapshot.data != null) {
          return const BottomNav(); // Main app if logged in
        }

        // If user is not logged in, show login screen
        return const LoginPage(); // Login screen if not logged in
      },
    );
  }
}
