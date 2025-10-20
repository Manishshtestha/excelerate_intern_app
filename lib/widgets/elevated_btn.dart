import 'package:flutter/material.dart';

// A reusable custom elevated button widget
// Provides customization for color, text, border radius, and padding
class ElevatedBtn extends StatelessWidget {
  final String text; // Text displayed on the button
  final VoidCallback onPressed; // Function executed when button is pressed
  final Color? color; // Background color of the button
  final Color? textColor; // Text color
  final double borderRadius; // Rounds the button corners
  final double padding; // Vertical padding for button size

  const ElevatedBtn({
    super.key,
    required this.text,
    required this.onPressed,
    this.color , // Default button color
    this.textColor , // Default text color
    this.borderRadius = 12, // Default rounded corners
    this.padding = 16, // Default padding
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Makes button take full available width
      child: Padding(
        // Adds padding around the button for spacing from edges
        padding: const EdgeInsetsDirectional.only(start: 12, end: 12, bottom: 8),
        
        // The main ElevatedButton widget
        child: ElevatedButton(
          // Styling for the button
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Theme.of(context).primaryColor, // Button background color
            foregroundColor: textColor ?? Colors.white,// Text/icon color
            padding: EdgeInsets.symmetric(vertical: padding), // Vertical padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
            ),
          ),

          // Action performed when button is pressed
          onPressed: onPressed,

          // Button label text
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16, // Font size for button text
              fontWeight: FontWeight.bold, // Bold text
            ),
          ),
        ),
      ),
    );
  }
}
