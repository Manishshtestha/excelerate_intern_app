import 'package:flutter/material.dart';

/// A reusable widget that displays a course card.
/// It supports both vertical and horizontal layouts and can trigger an action when tapped.
class CourseCard extends StatelessWidget {
  final String title; // Title of the course
  final String subtitle; // Subtitle or short description of the course
  final String imageUrl; // URL for the course thumbnail or image
  final bool isVerticalLayout; // Controls whether the layout is vertical or horizontal
  final VoidCallback? onTap; // Optional callback triggered when the card is tapped

  const CourseCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.isVerticalLayout,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detects tap gestures and executes the callback function
      onTap: onTap,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white, // Sets background color of the card
          borderRadius: BorderRadius.circular(16), // Adds rounded corners
          boxShadow: const [
            // Adds shadow effect to give depth
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),

        // The widget layout changes depending on the isVerticalLayout flag
        child: isVerticalLayout
            // ------------------- Vertical Layout -------------------
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top section with course image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // If the image fails to load, show a placeholder
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 120,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 40),
                      ),
                    ),
                  ),

                  // Bottom section with title and subtitle
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Displays the course title
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        // Displays the course subtitle or short description
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              )

            // ------------------- Horizontal Layout -------------------
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left section: text (title and subtitle)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Displays the course title
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),

                          // Displays the course subtitle
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Right section: course image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 160,
                      height: 120,
                      fit: BoxFit.cover,
                      // If the image fails to load, display a placeholder
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 200,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.image_not_supported, size: 30),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
