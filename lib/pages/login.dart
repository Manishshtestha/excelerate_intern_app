import 'package:excelerate_intern_app/widgets/elevated_btn.dart';
import 'package:excelerate_intern_app/widgets/input_field.dart';
import 'package:flutter/material.dart';

// Login screen where user enters email and password to access the app
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers to read text input from fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Function to handle login validation and navigation
    void login() {
      // Simple hardcoded authentication check
      if (_emailController.text == 'admin@gmail.com' &&
          _passwordController.text == 'admin123') {
        // Navigate to Bottom Navigation screen after successful login
        Navigator.pushReplacementNamed(context, '/bottomnav');

        // Show success message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login Successful')));
      } else {
        // Show error if credentials are invalid
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    }

    return Scaffold(
      // App bar with title
      appBar: AppBar(
        title: Text(
          'Level up',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          // Main column for login form + register link
          child: Column(
            children: [
              // Expands the login form to fill available space
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Keeps form compact
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page heading
                      Center(
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

                      // Email input field
                      InputField(
                        label: 'Email',
                        hint: 'Enter your email',
                        icon: Icons.mail_sharp,
                        controller: _emailController,
                        autoFocus: true,
                        fieldType: InputFieldType.email,
                        isRequired: true,
                      ),

                      // Password input field
                      InputField(
                        label: 'Password',
                        hint: 'Enter your password',
                        obscureText: true, // Hide text
                        icon: Icons.lock,
                        controller: _passwordController,
                        fieldType: InputFieldType.password,
                        isRequired: true,
                      ),

                      // "Forgot password" link
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 4),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Login button
                      ElevatedBtn(
                        text: 'Login',
                        onPressed: () {
                          login();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom text link to navigate to register page
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to Register Page
                    Navigator.pushNamed(context, '/register');
                  },
                  child: RichText(
                    text: const TextSpan(
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
    );
  }
}
