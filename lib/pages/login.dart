import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:excelerate_intern_app/widgets/elevated_btn.dart';
import 'package:excelerate_intern_app/widgets/input_field.dart';

/// The `LoginPage` class provides a form for user authentication.
/// Users can log in using their registered email and password.
/// It includes form validation, loading state, and navigation upon success.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ---------- Controllers & Form Key ----------
  final _formKey = GlobalKey<FormState>(); // Tracks and validates form fields
  final _emailController = TextEditingController(); // Stores email input
  final _passwordController = TextEditingController(); // Stores password input

  bool _isLoading = false; // Indicates when login is in progress

  // ---------- Lifecycle ----------
  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ---------- Login Function ----------
  /// Authenticates the user using Firebase Authentication.
  /// Displays error messages for invalid credentials or failed attempts.
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return; // Validate form inputs

    setState(() => _isLoading = true); // Show loading spinner

    try {
      // Attempt login using Firebase email/password authentication
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = credential.user;

      // If login is successful, navigate to BottomNav page
      if (user != null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/bottomnav');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Successful')),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle different authentication errors
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        default:
          message = 'Login failed. Please try again.';
      }

      // Show error message in a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      // Stop loading spinner
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // -------- AppBar --------
      appBar: AppBar(
        title: const Text(
          'Level up',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),

      // -------- Main Body --------
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ---------- Login Form Section ----------
                Expanded(
                  child: Center(
                    child: _isLoading
                        // Loading indicator when login is processing
                        ? const CircularProgressIndicator()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Page Title
                              const Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),

                              // ---------- Email Input Field ----------
                              InputField(
                                label: 'Email',
                                hint: 'Enter your email',
                                icon: Icons.mail_sharp,
                                controller: _emailController,
                                fieldType: InputFieldType.email,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),

                              // ---------- Password Input Field ----------
                              InputField(
                                label: 'Password',
                                hint: 'Enter your password',
                                obscureText: true,
                                icon: Icons.lock,
                                controller: _passwordController,
                                fieldType: InputFieldType.password,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // ---------- Login Button ----------
                              ElevatedBtn(
                                text: 'Login',
                                onPressed: _isLoading ? null : _login,
                              ),
                            ],
                          ),
                  ),
                ),

                // ---------- Register Redirect ----------
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: const Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Register now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
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
      ),
    );
  }
}
