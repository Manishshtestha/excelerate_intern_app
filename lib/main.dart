import 'package:excelerate_intern_app/pages/bottom_nav.dart';
import 'package:excelerate_intern_app/pages/catalog_page.dart';
import 'package:excelerate_intern_app/pages/feedback_page.dart';
import 'package:excelerate_intern_app/pages/login.dart';
import 'package:excelerate_intern_app/pages/profile_page.dart';
import 'package:excelerate_intern_app/pages/progress_page.dart';
import 'package:excelerate_intern_app/pages/register.dart';
import 'package:excelerate_intern_app/pages/splash_screen.dart';
import 'package:flutter/material.dart'; 

// The entry point of the Flutter app
void main() {
  runApp(MyApp()); // Runs the root widget of the application
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The first screen shown when the app starts
      home: SplashScreen(),

      // Removes the debug banner from the top-right corner
      debugShowCheckedModeBanner: false,

      // Defines all named routes for easy navigation throughout the app
      routes: {
        '/login': (context) => LoginPage(),         // Login screen route
        '/register': (context) => RegisterPage(),   // Registration screen route
        '/bottomnav': (context) => BottomNav(),     // Main bottom navigation screen
        '/catalog': (context) => CatalogPage(),     // Course catalog or list screen
        '/progress': (context) => ProgressPage(),   // User progress tracking page
        '/profile': (context) => ProfilePage(),     // User profile screen
        '/feedback': (context) => FeedbackScreen(), // (Optional) Feedback page if added later
      },
    );
  }
}
