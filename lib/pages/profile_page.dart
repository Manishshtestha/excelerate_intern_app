import 'package:flutter/material.dart';

// Profile page showing user info and enrolled courses
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Sample list of enrolled courses
  final courses = ['Flutter Basics', 'Dart Fundamentals', 'Python Basics','Node.js Essentials'];

  // Corresponding progress status for each course
  final progress = ['In Progress', 'Complete', 'In Progress', 'In Progress'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar section with profile title and settings menu
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          // Popup menu button (for Settings, Logout, etc.)
          PopupMenuButton<String>(
            onSelected: (value) {
              // TODO: Add functionality later (e.g., open settings page)
              print('You selected: $value'); // Placeholder for now
            },
            itemBuilder: (context) => [
              // Settings option
              PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),

              // Logout option — navigates back to login page
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
                onTap: () {
                  // Replace current route with Login Page
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ],
      ),

      // Body of the page (scrollable in case of overflow)
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile picture and user information
            Center(
              child: Column(
                children: [
                  SizedBox(height: 10),

                  // User avatar
                  CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(
                      'https://i.pinimg.com/1200x/67/2c/d6/672cd616936e481ef2632306731a87cd.jpg',
                    ),
                  ),

                  SizedBox(height: 20),

                  // User name (currently static, can be made dynamic)
                  Text(
                    'Sophia Carter', // TODO: Make dynamic (fetched from user data)
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Joined date (currently static, can be made dynamic)
                  Text(
                    'Joined 2 years ago', // TODO: Make dynamic
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Section title: "Courses"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Courses',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // List of enrolled courses with progress status
            ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: courses.length,
              shrinkWrap: true, // 👈 Makes ListView take only needed space
              physics: NeverScrollableScrollPhysics(), // Disable internal scroll

              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.book), // Course icon

                  // Course title
                  title: Text(courses[index]),

                  // Course progress status
                  subtitle: Text(
                    progress[index],
                    style: TextStyle(color: Colors.blue),
                  ),

                  // Handle tap on a course (can navigate later)
                  onTap: () {
                    print('Tapped on ${courses[index]}');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
