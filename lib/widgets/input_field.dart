import 'package:flutter/material.dart';

/// Enum representing different types of input fields.
/// Each type includes built-in validation logic.
enum InputFieldType { text, email, password, phone, number }

/// A reusable and customizable input field widget.
/// 
/// Features:
/// - Optional leading icon
/// - Password visibility toggle
/// - Field-specific validation (email, phone, number, etc.)
/// - Custom validator support
/// - Auto-focus and required field handling
class InputField extends StatefulWidget {
  final String label; // Label name for identification (not displayed on UI)
  final String hint; // Placeholder text inside the input field
  final IconData? icon; // Optional leading icon
  final bool obscureText; // Whether the text should be hidden (for passwords)
  final TextEditingController? controller; // Controls the text being edited
  final bool autoFocus; // Automatically focuses on this field when screen loads
  final String? Function(String?)? validator; // Custom validation function
  final String? errorText; // Custom error message (if provided externally)
  final bool isRequired; // Whether this field must be filled
  final InputFieldType fieldType; // Determines the type of input and validation

  const InputField({
    super.key,
    required this.label,
    required this.hint,
    this.icon,
    this.obscureText = false,
    this.controller,
    this.autoFocus = true,
    this.validator,
    this.errorText,
    this.isRequired = false,
    this.fieldType = InputFieldType.text,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

/// Extension method to allow validation of InputField externally.
extension InputFieldValidation on InputField {
  /// Validates the field value based on type or custom validator.
  /// Returns an error message string if invalid, otherwise null.
  String? validate() {
    final controller = this.controller;
    if (controller == null) return null;

    final value = controller.text;

    // Use custom validator if defined.
    if (this.validator != null) {
      return this.validator!(value);
    }

    // Empty field validation.
    if (value.trim().isEmpty) {
      if (this.isRequired) {
        return 'This field is required';
      }
      return null;
    }

    // Apply field type–specific validation logic.
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
        // No additional validation for text fields.
        break;
    }
    return null;
  }
}

/// The state class responsible for handling user interaction and validation.
class _InputFieldState extends State<InputField> {
  late bool _obscureText; // Tracks whether password is hidden
  String? _errorText; // Stores the current error message
  bool _hasError = false; // Indicates if the field currently has an error

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText; // Initialize text visibility
    _errorText = widget.errorText; // Initialize error message if provided
    _hasError = _errorText != null; // Set error flag accordingly
  }

  /// Internal validator method to handle built-in field type validations.
  String? _validateInput(String? value) {
    // Custom validator (if provided externally)
    if (widget.validator != null) {
      return widget.validator!(value);
    }

    // Handle empty values
    if (value == null || value.trim().isEmpty) {
      if (widget.isRequired) {
        return 'This field is required';
      }
      return null;
    }

    // Apply built-in type validation
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
        // No validation for basic text input.
        break;
    }
    return null;
  }

  /// Performs validation and updates the widget's error state.
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
      // Adds spacing between multiple input fields.
      padding: const EdgeInsetsDirectional.only(start: 12, end: 12, bottom: 8),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller, // Links to provided controller
            obscureText: _obscureText, // Toggles password visibility
            autofocus: widget.autoFocus, // Focuses automatically if enabled
            keyboardType: _getKeyboardType(), // Keyboard type per field type
            onChanged: (_) => _validateField(), // Revalidates on every input
            onSubmitted: (_) => _validateField(), // Revalidates on submit
            decoration: InputDecoration(
              prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
              hintText: widget.hint,

              // Default border style
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              // Border when enabled but unfocused
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _hasError ? Colors.red : Colors.grey[300]!,
                  width: 1,
                ),
              ),

              // Border when focused
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _hasError ? Colors.red : Colors.blue,
                  width: 2,
                ),
              ),

              // Borders for error states
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),

              // Background color changes based on error state
              filled: true,
              fillColor: _hasError ? Colors.red[50] : Colors.grey[100],

              // Error text displayed below input field
              errorText: _errorText,

              // Password visibility toggle button
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: _hasError ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  /// Returns a suitable keyboard type for each field type.
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
