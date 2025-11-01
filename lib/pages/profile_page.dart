import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excelerate_intern_app/models/user_model.dart'; // Model representing user data

/// The `ProfilePage` displays the logged-in user's personal information,
/// enrolled courses, and provides options for logout and future settings access.
/// It retrieves user data from Firestore based on the authenticated user's UID.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ---------- State Variables ----------
  UserModel? _userModel; // Stores fetched user data
  bool _isLoading = true; // Controls loading indicator visibility

  // ---------- Lifecycle ----------
  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Load user info on page start
  }

  // ---------- Fetch User Data ----------
  /// Retrieves the currently logged-in user's data from Firestore.
  /// If user exists, maps Firestore document to `UserModel`.
  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // If no user is logged in, stop loading
        setState(() => _isLoading = false);
        return;
      }

      // Fetch user document from Firestore using UID
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      // Convert Firestore document to UserModel if it exists
      if (doc.exists && doc.data() != null) {
        _userModel = UserModel.fromMap(doc.data()!);
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() => _isLoading = false);
    }
  }

  // ---------- Logout Function ----------
  /// Signs the user out of Firebase and redirects to the login page.
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    // Show loading indicator while data is being fetched
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Handle case where no user data is available
    if (_userModel == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('No user data found')),
      );
    }

    final user = _userModel!;

    return Scaffold(
      // ---------- AppBar ----------
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') _logout();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),

      // ---------- Main Body ----------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- User Info Section ----------
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Profile picture (static example)
                  const CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(
                      'https://i.pinimg.com/1200x/67/2c/d6/672cd616936e481ef2632306731a87cd.jpg',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Display Name
                  Text(
                    user.displayName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Email
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                  ),

                  // Account creation date
                  const SizedBox(height: 4),
                  Text(
                    'Joined on ${user.createdAt.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------- Enrolled Courses Section ----------
            const Text(
              'Enrolled Courses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            // Display message if no courses are enrolled
            if (user.enrolledCourses.isEmpty)
              const Text(
                'No courses enrolled yet.',
                style: TextStyle(color: Colors.grey),
              )
            else
              // List of enrolled courses with progress
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: user.enrolledCourses.length,
                itemBuilder: (context, index) {
                  final course = user.enrolledCourses[index];
                  final progress = user.courseProgress[course] ?? 'In Progress';
                  return ListTile(
                    leading: const Icon(Icons.book),
                    title: Text(course),
                    subtitle: Text(
                      progress,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
