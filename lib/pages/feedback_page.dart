import 'package:excelerate_intern_app/widgets/elevated_btn.dart';
import 'package:flutter/material.dart';

// Feedback screen for a specific course — lets users rate and review
class FeedbackScreen extends StatefulWidget {
  final String? courseTitle; // Title of the course being reviewed
  final String? courseMentor; // Optional course instructor name

  const FeedbackScreen({super.key, this.courseTitle, this.courseMentor});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int selectedRating = 0; // Stores the selected star rating (1–5)
  final TextEditingController _feedbackController =
      TextEditingController(); // Controller for feedback text input
  String selectedCategory = 'Course Content'; // Default feedback category

  // List of predefined feedback categories
  final List<String> feedbackCategories = [
    'Course Content',
    'Instructor',
    'Difficulty Level',
    'Learning Experience',
    'Technical Issues',
    'Other',
  ];

  // Mock feedback data — can be replaced by API or database data
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
    // Clean up text controller when the widget is disposed
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.courseTitle == null ? 'App Feedback' : 'Course Feedback',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Course Info Header ---
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
                    // Show mentor info if available
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

              // --- Rating Section ---
              const Text(
                'Rate this course',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 5-star rating row
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRating = index + 1; // Update rating
                        });
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

              // Rating label (e.g., “Excellent!”, “Good”)
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

              // Category chips (horizontal wrapping list)
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
                        setState(() {
                          selectedCategory = category;
                        });
                      }
                    },
                    selectedColor: Colors.blue[100],
                    backgroundColor: Colors.grey[100],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.blue[700] : Colors.grey[700],
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
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
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Share your thoughts about this course...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 24),

              // --- Submit Button ---
              ElevatedBtn(text: 'Submit Feedback', onPressed: _submitFeedback),

              const SizedBox(height: 32),

              // --- Reviews Summary Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Student Reviews',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${previousFeedback.length} reviews',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // --- Rating Summary Overview ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  children: [
                    // Average rating score
                    Column(
                      children: [
                        const Text(
                          '4.7',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < 4 ? Icons.star : Icons.star_half,
                              size: 16,
                              color: Colors.amber,
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),

                    // Rating bar distribution
                    Expanded(
                      child: Column(
                        children: [
                          _buildRatingBar(5, 0.8),
                          _buildRatingBar(4, 0.15),
                          _buildRatingBar(3, 0.03),
                          _buildRatingBar(2, 0.01),
                          _buildRatingBar(1, 0.01),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- Display Individual Feedback Cards ---
              ...previousFeedback.map((feedback) {
                return _buildFeedbackCard(feedback);
              }).toList(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Builds a single rating bar (used in summary)
  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$stars', style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Icon(Icons.star, size: 12, color: Colors.amber[700]),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[700]!),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  // Builds a card for each feedback item
  Widget _buildFeedbackCard(Map<String, dynamic> feedback) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer info + rating
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue[100],
                child: Text(
                  feedback['user'][0], // First letter of name
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedback['user'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      feedback['date'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              // Rating badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Text(
                      '${feedback['rating']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.amber[900],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Category tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              feedback['category'],
              style: TextStyle(fontSize: 11, color: Colors.grey[700]),
            ),
          ),

          const SizedBox(height: 8),

          // Feedback comment text
          Text(
            feedback['comment'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          // Helpful / Reply buttons
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_outlined, size: 16),
                label: const Text('Helpful (12)'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.reply, size: 16),
                label: const Text('Reply'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Returns descriptive text based on star rating
  String _getRatingText(int rating) {
    switch (rating) {
      case 5:
        return 'Excellent!';
      case 4:
        return 'Very Good';
      case 3:
        return 'Good';
      case 2:
        return 'Needs Improvement';
      case 1:
        return 'Poor';
      default:
        return '';
    }
  }

  // Handles feedback submission validation and success message
  void _submitFeedback() {
    // Validation: ensure rating and text are provided
    if (selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write your feedback'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Success confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your feedback!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Reset form state
    setState(() {
      selectedRating = 0;
      selectedCategory = 'Course Content';
      _feedbackController.clear();
    });

    // Return to previous screen after short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }
}
