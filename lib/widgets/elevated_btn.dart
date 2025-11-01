import 'package:flutter/material.dart';

/// A reusable custom elevated button widget.
/// Provides customization options such as:
/// - background color
/// - text color
/// - border radius
/// - vertical padding
/// This helps maintain consistency and reusability across the app.
class ElevatedBtn extends StatelessWidget {
  // The text displayed on the button.
  final String text;

  // The function executed when the button is pressed.
  final VoidCallback? onPressed;

  // The background color of the button.
  final Color? color;

  // The color of the button text.
  final Color? textColor;

  // Determines how rounded the corners of the button are.
  final double borderRadius;

  // Vertical padding to control button height.
  final double padding;

  /// Constructor with default values for borderRadius and padding.
  const ElevatedBtn({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.borderRadius = 12,
    this.padding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Makes the button expand to take the full available width.
      width: double.infinity,
      child: Padding(
        // Adds padding around the button to prevent it from sticking
        // to screen edges or other widgets.
        padding: const EdgeInsetsDirectional.only(
          start: 12,
          end: 12,
          bottom: 8,
        ),

        // The main ElevatedButton widget with customizable styling.
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            // Sets background color. Uses provided color or defaults to
            // app theme's primary color.
            backgroundColor: color ?? Theme.of(context).primaryColor,

            // Sets text and icon color.
            foregroundColor: textColor ?? Colors.white,

            // Adds vertical padding to adjust button height.
            padding: EdgeInsets.symmetric(vertical: padding),

            // Applies rounded corners using borderRadius.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),

          // Executes provided function when pressed.
          onPressed: onPressed,

          // Button label text with bold style and readable size.
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
