import 'package:flutter/material.dart';
import 'feedback_page.dart';

// Course Detail Page — displays detailed info for a selected course
class CourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> course; // Contains course data (title, modules, etc.)

  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  bool isEnrolled = false; // Tracks enrollment status of user

  @override
  void dispose() {
    _commentController.dispose(); // Dispose controller to free memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extract modules and comments from course map
    final modules = widget.course['modules'] as Map<String, dynamic>;
    final comments = widget.course['comments'] as List<dynamic>;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible AppBar with course image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Course image
                  Image.network(
                    widget.course['imageUrl'],
                    fit: BoxFit.cover,
                    // Fallback in case image fails to load
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                  // Gradient overlay (darkens bottom for readability)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main course content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Title
                  Text(
                    widget.course['title'],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Course Subtitle
                  Text(
                    widget.course['subtitle'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Course Status Badge (e.g., "Upcoming", "Ongoing")
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(widget.course['status'])
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.course['status'],
                      style: TextStyle(
                        color: _getStatusColor(widget.course['status']),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Instructor / Mentor Information
                  Row(
                    children: [
                      // Circular avatar showing first letter of mentor name
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          widget.course['mentor'][0],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Mentor name and label
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Instructor',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            widget.course['mentor'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Course Description
                  const Text(
                    'About this course',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.course['description'],
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Course Modules List
                  const Text(
                    'Course Modules',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Loop through all modules and display each
                  ...modules.entries.map((module) {
                    return _buildModuleItem(
                      module.key,
                      module.value,
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // Student Feedback Section Title + Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Student Feedback',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Button to navigate to Feedback Screen
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedbackScreen(
                                courseTitle: widget.course['title'],
                                courseMentor: widget.course['mentor'],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.rate_review, size: 18),
                        label: const Text('Write Review'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Show message if no comments yet
                  if (comments.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'No feedback yet. Be the first to comment!',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  // Otherwise, show all comments
                  else
                    ...comments.map((comment) {
                      return _buildCommentItem(
                        comment['user'],
                        comment['comment'],
                      );
                    }).toList(),

                  const SizedBox(height: 100), // Space before bottom button
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom sticky button for enrollment
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            // Top shadow for elevation effect
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnrolled ? Colors.green :Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // Toggle enrollment status
              onPressed: () {
                setState(() {
                  isEnrolled = !isEnrolled;
                });
                // Show feedback message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEnrolled
                          ? 'Successfully enrolled!'
                          : 'Enrollment cancelled',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              // Button text changes dynamically
              child: Text(
                isEnrolled ? 'Continue Learning' : 'Enroll Now',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builds each module box with title + status icon
  Widget _buildModuleItem(String title, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon based on module status (complete, in progress, etc.)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getModuleIcon(status),
              color: _getStatusColor(status),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Module title and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 13,
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builds each comment block with username + comment text
  Widget _buildCommentItem(String user, String comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar and name
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue[100],
                child: Text(
                  user[0], // First letter of username
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                user,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Comment text
          Text(
            comment,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // Returns color based on status (used for both module and course)
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Complete':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      case 'Not Started':
        return Colors.grey;
      case 'Upcoming':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Returns appropriate icon for module status
  IconData _getModuleIcon(String status) {
    switch (status) {
      case 'Complete':
        return Icons.check_circle;
      case 'In Progress':
        return Icons.play_circle;
      case 'Not Started':
        return Icons.circle_outlined;
      default:
        return Icons.circle_outlined;
    }
  }
}
