import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:excelerate_intern_app/widgets/elevated_btn.dart';
import 'package:excelerate_intern_app/widgets/input_field.dart';
import 'package:excelerate_intern_app/models/user_model.dart';
import 'package:excelerate_intern_app/services/firestore_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(_nameController.text.trim());

        final userModel = UserModel(
          uid: user.uid,
          email: user.email!,
          displayName: _nameController.text.trim(),
          createdAt: DateTime.now(),
        );

        await FirestoreService.createUser(userModel);

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/bottomnav');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Successful')),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        case 'weak-password':
          message = 'Password must be at least 6 characters.';
          break;
        default:
          message = 'Registration failed. Please try again.';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Level up',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Full Name
                              InputField(
                                label: 'Full Name',
                                hint: 'Enter your full name',
                                icon: Icons.person,
                                controller: _nameController,
                                fieldType: InputFieldType.text,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Full name is required';
                                  }
                                  return null;
                                },
                              ),

                              // Email
                              InputField(
                                label: 'Email',
                                hint: 'Enter your email',
                                icon: Icons.mail,
                                controller: _emailController,
                                fieldType: InputFieldType.email,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+',
                                  ).hasMatch(value)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),

                              // Password
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
                                  if(!value.contains(RegExp(r'[A-Z]'))){
                                    return 'Password must contain at least one uppercase letter';
                                  }
                                  if(!value.contains(RegExp(r'[a-z]'))){
                                    return 'Password must contain at least one lowercase letter';
                                  }
                                  if(!value.contains(RegExp(r'[0-9]'))){
                                    return 'Password must contain at least one number';
                                  }
                                  if(!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))){
                                    return 'Password must contain at least one special character';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              ElevatedBtn(
                                text: 'Register',
                                onPressed: _isLoading ? null : register,
                              ),
                            ],
                          ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: const Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Login here",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
