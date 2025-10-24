import 'package:flutter/material.dart';
import 'package:excelerate_intern_app/widgets/elevated_btn.dart';
import 'package:excelerate_intern_app/widgets/input_field.dart';

// A StatelessWidget that displays the user registration screen
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Custom validator functions
  String? _customNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.contains(RegExp(r'[0-9]'))) {
      return 'Name should not contain numbers';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name should only contain letters and spaces';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }

  String? _customPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar at the top of the screen
      appBar: AppBar(
        title: Text(
          'Level up', // App title text
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        ),
        centerTitle: true, // Centers the title
        leading: BackButton(
          // Back button to return to the previous screen
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        // Ensures UI doesn't overlap with system status bar or notches
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Adds consistent padding
          child: Column(
            children: [
              // Expanded makes the main content take up available space
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Shrinks to content height
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Register heading
                        Center(
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 40,
                        ), // Spacing before input fields
                        // Input field for full name
                        InputField(
                          label: 'Full Name',
                          hint: 'Full Name',
                          icon: Icons.person, // (Optional) Can add icon
                          controller: _nameController,
                          fieldType: InputFieldType.text,
                          isRequired: true,
                          validator: _customNameValidator,
                        ),

                        // Input field for email
                        InputField(
                          label: 'Email',
                          hint: 'Email',
                          icon: Icons.mail_sharp,
                          controller: _emailController,
                          fieldType: InputFieldType.email,
                          isRequired: true,
                        ),

                        // Input field for password
                        InputField(
                          label: 'Password',
                          hint: 'Password',
                          obscureText: true, // Hides entered text
                          icon: Icons.lock,
                          controller: _passwordController,
                          fieldType: InputFieldType.password,
                          isRequired: true,
                        ),

                        // Input field for confirm password
                        InputField(
                          label: 'Password',
                          hint: 'Confirm Password',
                          obscureText: true,
                          icon: Icons.lock,
                          controller: _confirmPasswordController,
                          fieldType: InputFieldType.password,
                          validator: _customPasswordValidator,
                          isRequired: true,
                        ),

                        const SizedBox(height: 20), // Space before button
                        // Register button
                        ElevatedBtn(
                          text: 'Register',
                          onPressed: () {
                            // TODO: Implement actual user registration logic here.
                            // On success, navigate to the main app screen.
                            Navigator.pushReplacementNamed(
                              context,
                              '/bottomnav',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
