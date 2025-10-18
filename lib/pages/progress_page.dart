import 'package:flutter/material.dart';

// ProgressPage: Displays user's overall learning progress and stats
class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  // Mock data — replace later with dynamic data from backend or state management
  final List<Map<String, dynamic>> enrolledCourses = [
    {
      'title': 'Flutter Basics',
      'progress': 0.65,
      'completedModules': 2,
      'totalModules': 3,
      'hoursSpent': 12.5,
      'lastAccessed': '2 days ago',
    },
    {
      'title': 'Dart Fundamentals',
      'progress': 1.0,
      'completedModules': 3,
      'totalModules': 3,
      'hoursSpent': 18.0,
      'lastAccessed': '1 week ago',
    },
    {
      'title': 'Python Basics',
      'progress': 0.33,
      'completedModules': 1,
      'totalModules': 3,
      'hoursSpent': 6.0,
      'lastAccessed': '3 days ago',
    },
    {
      'title': 'Node.js Essentials',
      'progress': 0.5,
      'completedModules': 2,
      'totalModules': 4,
      'hoursSpent': 10.0,
      'lastAccessed': '5 days ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate summary statistics
    final totalCourses = enrolledCourses.length;
    final completedCourses =
        enrolledCourses.where((c) => c['progress'] == 1.0).length;
    final inProgressCourses = totalCourses - completedCourses;

    // Total hours of study across all courses
    final totalHours = enrolledCourses.fold<double>(
      0,
      (sum, course) => sum + course['hoursSpent'],
    );

    // Average overall progress percentage
    final overallProgress = enrolledCourses.fold<double>(
          0,
          (sum, course) => sum + course['progress'],
        ) /
        totalCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add filter/sort functionality
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),

      // Entire page scrollable vertically
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for content
            const Center(
              child: Text('Progress content goes here'),
            ),
          ],
        ),
      ),
    );
  }
}