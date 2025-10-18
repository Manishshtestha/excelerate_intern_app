import 'package:flutter/material.dart';

// A reusable widget that displays a course card
// It supports both vertical and horizontal layouts.
class CourseCard extends StatelessWidget {
  final String title; // Title of the course
  final String subtitle; // Subtitle or short description
  final String imageUrl; // URL of the course image
  final bool isVerticalLayout; // To toggle between vertical or horizontal layout
  final VoidCallback? onTap; // Optional callback when the card is tapped

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
      // Detects tap gesture on the card
      onTap: onTap,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white, // Card background color
          borderRadius: BorderRadius.circular(16), // Rounded corners
          boxShadow: const [
            // Adds soft shadow for elevation effect
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),

        // Conditional layout based on isVerticalLayout flag
        child: isVerticalLayout
            // ----- Vertical Layout -----
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top image section
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // Fallback widget if image fails to load
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 120,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 40),
                      ),
                    ),
                  ),

                  // Text section below image
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Course title
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

                        // Course subtitle
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

            // ----- Horizontal Layout -----
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text section (on the left side)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Course title
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

                          // Course subtitle
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

                  // Image section (on the right side)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 160,
                      height: 120,
                      fit: BoxFit.cover,
                      // Fallback if image fails to load
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
