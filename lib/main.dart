import 'package:excelerate_intern_app/pages/bottom_nav.dart';
import 'package:excelerate_intern_app/pages/login.dart';
import 'package:excelerate_intern_app/pages/profile.dart';
import 'package:excelerate_intern_app/pages/progress.dart';
import 'package:excelerate_intern_app/pages/register.dart';
import 'package:excelerate_intern_app/pages/splash_screen.dart';
import 'package:excelerate_intern_app/pages/catalog.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/bottomnav':(context)=>BottomNav(),
        '/catalog':(context) => CatalogPage(),
        '/progress':(context) => ProgressPage(),
        '/profile':(context)=> ProfilePage(),
      },
    );
  }
}
