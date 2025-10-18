import 'package:flutter/material.dart';

// A reusable input field widget with optional icon, label, and password visibility toggle
class InputField extends StatefulWidget { 
  final String label; // Label or name for the input field (not shown visually)
  final String hint; // Hint text shown inside the field
  final IconData? icon; // Optional leading icon
  final bool obscureText; // Determines if the text should be hidden (for passwords)
  final TextEditingController? controller; // Controller to access/modify text
  final bool autoFocus; // Whether the field should focus automatically

  const InputField({
    super.key,
    required this.label,
    required this.hint,
    this.icon,
    this.obscureText = false, // Default: not obscured
    this.controller,
    this.autoFocus = true, // Default: auto-focus enabled
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  // Tracks visibility of password text
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // Initialize the obscureText value from widget
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Adds spacing around each input field
      padding: const EdgeInsetsDirectional.only(start: 12, end: 12, bottom: 8),

      // Text input area
      child: TextField(
        controller: widget.controller, // Binds input to a controller (if provided)
        obscureText: _obscureText, // Hides text for passwords
        autofocus: widget.autoFocus, // Automatically focuses if true

        decoration: InputDecoration(
          // Optional leading icon inside the input
          prefixIcon: widget.icon != null ? Icon(widget.icon) : null,

          // Placeholder hint text
          hintText: widget.hint,

          // Input border style
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),

          // Light background for better visibility
          filled: true,
          fillColor: Colors.grey[100],

          // 👁️ Toggle button for password visibility
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    // Switches between "eye open" and "eye closed"
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Toggle text visibility when pressed
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null, // No suffix icon for normal text fields
        ),
      ),
    );
  }
}
