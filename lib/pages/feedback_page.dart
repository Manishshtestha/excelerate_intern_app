import 'package:excelerate_intern_app/widgets/elevated_btn.dart';
import 'package:flutter/material.dart';

/// FeedbackScreen — Displays a detailed course feedback interface.
/// Allows users to rate a course, choose a feedback category, write a comment,
/// and view other students’ reviews.
class FeedbackScreen extends StatefulWidget {
  final String? courseTitle; // Title of the course being reviewed (optional)
  final String? courseMentor; // Name of the course instructor (optional)

  const FeedbackScreen({super.key, this.courseTitle, this.courseMentor});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int selectedRating = 0; // Currently selected star rating (1–5)
  final TextEditingController _feedbackController =
      TextEditingController(); // Controller for feedback text input
  String selectedCategory = 'Course Content'; // Default feedback category

  // Predefined list of feedback categories
  final List<String> feedbackCategories = [
    'Course Content',
    'Instructor',
    'Difficulty Level',
    'Learning Experience',
    'Technical Issues',
    'Other',
  ];

  // Mock list of previous feedback (can be replaced with API or Firestore data)
  final List<Map<String, dynamic>> previousFeedback = [
    {
      'user': 'Sarah Johnson',
      'rating': 5,
      'comment':
          'Excellent course! The instructor explains complex concepts very clearly.',
      'date': '2 days ago',
      'category': 'Course Content',
    },
    {
      'user': 'Michael Chen',
      'rating': 4,
      'comment':
          'Great content, but some modules could use more practical examples.',
      'date': '5 days ago',
      'category': 'Learning Experience',
    },
    {
      'user': 'Emily Rodriguez',
      'rating': 5,
      'comment': 'Love the pace and structure. Very beginner-friendly!',
      'date': '1 week ago',
      'category': 'Instructor',
    },
  ];

  @override
  void dispose() {
    // Dispose text controller when widget is removed from widget tree
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ---------- App Bar ----------
      appBar: AppBar(
        title: Text(
          widget.courseTitle == null ? 'App Feedback' : 'Course Feedback',
        ),
        centerTitle: true,
      ),

      // ---------- Page Content ----------
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Course Info / Header Section ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A5ACD), Color(0xFF4169E1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.courseTitle == null
                          ? 'Share Your Feedback'
                          : 'Share Your Experience',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.courseTitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.courseTitle!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                    // Display mentor info if provided
                    if (widget.courseMentor != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Instructor: ${widget.courseMentor}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- Star Rating Section ---
              const Text(
                'Rate this course',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 5-Star Rating Bar
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedRating = index + 1);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          index < selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          size: 40,
                          color: Colors.amber,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Rating Description (e.g., “Excellent!”)
              if (selectedRating > 0) ...[
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _getRatingText(selectedRating),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // --- Feedback Category Section ---
              const Text(
                'Feedback Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Category Selector Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: feedbackCategories.map((category) {
                  final isSelected = selectedCategory == category;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => selectedCategory = category);
                      }
                    },
                    selectedColor: Colors.blue[100],
                    backgroundColor: Colors.grey[100],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.blue[700] : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // --- Feedback Text Field ---
              const Text(
                'Your Feedback',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your comments here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

// --- Submit Button ---
              Center(
                child: ElevatedBtn(
                  text: 'Submit Feedback',
                  onPressed: () {
                    // handle feedback submission logic here
                    print('Rating: $selectedRating');
                    print('Category: $selectedCategory');
                    print('Feedback: ${_feedbackController.text}');
                  },
                ),
              ),

              const SizedBox(height: 32),

// --- Previous Feedback Section ---
              const Text(
                'Other Students\' Feedback',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Column(
                children: previousFeedback.map((fb) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(fb['user']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < fb['rating'] ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 18,
                              );
                            }),
                          ),
                          Text(fb['comment']),
                          Text(
                            '${fb['category']} • ${fb['date']}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent!';
      default:
        return '';
    }
  }
}
