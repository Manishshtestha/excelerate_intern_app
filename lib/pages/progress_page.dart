import 'package:flutter/material.dart';

/// ProgressPage — Displays the user's learning statistics,
/// including enrolled courses, completion progress, and goals.
class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  // Mock data — In a real app, this would come from Firebase or a state manager
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
    // --- Calculate progress summary stats ---
    final totalCourses = enrolledCourses.length;
    final completedCourses =
        enrolledCourses.where((c) => c['progress'] == 1.0).length;
    final inProgressCourses = totalCourses - completedCourses;

    // Total hours spent across all courses
    final totalHours = enrolledCourses.fold<double>(
      0,
      (sum, course) => sum + course['hoursSpent'],
    );

    // Overall average progress (0 to 1)
    final overallProgress = enrolledCourses.fold<double>(
          0,
          (sum, course) => sum + course['progress'],
        ) /
        totalCourses;

    // --- Main Page Layout ---
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Option for filtering or sorting courses (to be implemented)
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),

      // Scrollable page
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔵 Overall Statistics Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A5ACD), Color(0xFF4169E1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Overall Progress',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Circular progress indicator showing overall % completion
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: overallProgress,
                          strokeWidth: 10,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${(overallProgress * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Complete',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Summary stats row (total, completed, hours)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(Icons.book_outlined, '$totalCourses', 'Enrolled'),
                      _buildStatItem(Icons.check_circle_outline, '$completedCourses', 'Completed'),
                      _buildStatItem(Icons.access_time, '${totalHours.toInt()}h', 'Learning'),
                    ],
                  ),
                ],
              ),
            ),

            // 🟠 Quick Stats Cards (In progress, weekly)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuickStatCard(
                      'In Progress',
                      '$inProgressCourses',
                      Icons.play_circle_outline,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickStatCard(
                      'This Week',
                      '8h',
                      Icons.calendar_today,
                      Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🧭 Course Progress Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Course Progress',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to detailed course list (to be implemented)
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),

            // 📘 List of enrolled courses and progress bars
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: enrolledCourses.length,
              itemBuilder: (context, index) {
                final course = enrolledCourses[index];
                return _buildCourseProgressCard(course);
              },
            ),

            const SizedBox(height: 24),

            // 🏆 Weekly Goal Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.emoji_events, color: Colors.amber[700]),
                        const SizedBox(width: 8),
                        const Text(
                          'Weekly Goal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Complete 10 hours of learning',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),

                    // Weekly progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 0.8,
                        minHeight: 10,
                        backgroundColor: Colors.amber[100],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.amber[700]!,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '8 of 10 hours completed',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- Helper Widget: Stat Item inside overall progress card ---
  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  // --- Helper Widget: Quick Statistic Card (small info boxes) ---
  Widget _buildQuickStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon in colored background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // --- Helper Widget: Individual Course Progress Card ---
  Widget _buildCourseProgressCard(Map<String, dynamic> course) {
    final progress = course['progress'] as double;
    final isCompleted = progress == 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + progress percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  course['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? Colors.green : Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Course details: modules, time spent, last accessed
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.playlist_play, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${course['completedModules']}/${course['totalModules']} modules',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${course['hoursSpent']}h',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              Text(
                course['lastAccessed'],
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
