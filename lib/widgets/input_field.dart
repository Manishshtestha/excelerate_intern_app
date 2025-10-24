import 'package:flutter/material.dart';

// Enum for different input field types with built-in validation
enum InputFieldType { text, email, password, phone, number }

// A reusable input field widget with optional icon, label, password visibility toggle, and validation
class InputField extends StatefulWidget {
  final String label; // Label or name for the input field (not shown visually)
  final String hint; // Hint text shown inside the field
  final IconData? icon; // Optional leading icon
  final bool obscureText; // Determines if the text should be hidden (for passwords)
  final TextEditingController? controller; // Controller to access/modify text
  final bool autoFocus; // Whether the field should focus automatically
  final String? Function(String?)? validator; // Custom validation function
  final String? errorText; // Custom error message to display
  final bool isRequired; // Whether the field is required
  final InputFieldType fieldType; // Type of validation to apply

  const InputField({
    super.key,
    required this.label,
    required this.hint,
    this.icon,
    this.obscureText = false, // Default: not obscured
    this.controller,
    this.autoFocus = true, // Default: auto-focus enabled
    this.validator,
    this.errorText,
    this.isRequired = false,
    this.fieldType = InputFieldType.text,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

// Extension to add validation methods to InputField
extension InputFieldValidation on InputField {
  // Method to validate the field from outside
  String? validate() {
    final controller = this.controller;
    if (controller == null) return null;

    final value = controller.text;

    // Use custom validator if provided
    if (this.validator != null) {
      return this.validator!(value);
    }

    // Handle empty values
    if (value.trim().isEmpty) {
      if (this.isRequired) {
        return 'This field is required';
      }
      return null;
    }

    // Apply field type specific validation
    switch (this.fieldType) {
      case InputFieldType.email:
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        break;
      case InputFieldType.password:
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$').hasMatch(value)) {
          return 'Password must contain letters and numbers';
        }
        if (!RegExp(r'^(?=.*[!@#$%^&*])').hasMatch(value)) {
          return 'Password must contain at least one special character';
        }
        break;
      case InputFieldType.phone:
        if (!RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        break;
      case InputFieldType.number:
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        break;
      case InputFieldType.text:
        // No specific validation for text fields
        break;
    }

    return null;
  }
}

class _InputFieldState extends State<InputField> {
  // Tracks visibility of password text
  late bool _obscureText;
  // Tracks validation state
  String? _errorText;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // Initialize the obscureText value from widget
    _obscureText = widget.obscureText;
    // Initialize error state
    _errorText = widget.errorText;
    _hasError = _errorText != null;
  }

  // Validates input based on field type and custom validator
  String? _validateInput(String? value) {
    // Use custom validator if provided
    if (widget.validator != null) {
      return widget.validator!(value);
    }

    // Handle null or empty values
    if (value == null || value.trim().isEmpty) {
      if (widget.isRequired) {
        return 'This field is required';
      }
      return null;
    }

    // Apply field type specific validation
    switch (widget.fieldType) {
      case InputFieldType.email:
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        break;
      case InputFieldType.password:
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        break;
      case InputFieldType.phone:
        if (!RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        break;
      case InputFieldType.number:
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        break;
      case InputFieldType.text:
        // No specific validation for text fields
        break;
    }

    return null;
  }

  // Validates the current input and updates error state
  void _validateField() {
    final value = widget.controller?.text;
    final error = _validateInput(value);

    setState(() {
      _errorText = error;
      _hasError = error != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Adds spacing around each input field
      padding: const EdgeInsetsDirectional.only(start: 12, end: 12, bottom: 8),

      // Text input area with validation
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller:
                widget.controller, // Binds input to a controller (if provided)
            obscureText: _obscureText, // Hides text for passwords
            autofocus: widget.autoFocus, // Automatically focuses if true
            keyboardType: _getKeyboardType(), // Set appropriate keyboard type
            onChanged: (value) {
              // Validate on every change
              _validateField();
            },
            onSubmitted: (value) {
              // Validate when user submits
              _validateField();
            },

            decoration: InputDecoration(
              // Optional leading icon inside the input
              prefixIcon: widget.icon != null ? Icon(widget.icon) : null,

              // Placeholder hint text
              hintText: widget.hint,

              // Input border style with error state
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _hasError ? Colors.red : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _hasError ? Colors.red : Colors.blue,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),

              // Light background for better visibility
              filled: true,
              fillColor: _hasError ? Colors.red[50] : Colors.grey[100],

              // Error text
              errorText: _errorText,

              // 👁️ Toggle button for password visibility
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        // Switches between "eye open" and "eye closed"
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: _hasError ? Colors.red : Colors.grey,
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
        ],
      ),
    );
  }

  // Returns appropriate keyboard type based on field type
  TextInputType _getKeyboardType() {
    switch (widget.fieldType) {
      case InputFieldType.email:
        return TextInputType.emailAddress;
      case InputFieldType.phone:
        return TextInputType.phone;
      case InputFieldType.number:
        return TextInputType.number;
      case InputFieldType.password:
      case InputFieldType.text:
        return TextInputType.text;
    }
  }
}
