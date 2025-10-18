import 'package:flutter/material.dart';
import 'package:excelerate_intern_app/widgets/elevated_btn.dart';
import 'package:excelerate_intern_app/widgets/input_field.dart';

// A StatelessWidget that displays the user registration screen
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Shrinks to content height
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

                      const SizedBox(height: 40), // Spacing before input fields

                      // Input field for full name
                      InputField(
                        label: 'Full Name',
                        hint: 'Full Name',
                        // icon: Icons.person, // (Optional) Can add icon
                      ),

                      // Input field for email
                      InputField(
                        label: 'Email',
                        hint: 'Email',
                        // icon: Icons.mail_sharp,
                      ),

                      // Input field for password
                      InputField(
                        label: 'Password',
                        hint: 'Password',
                        obscureText: true, // Hides entered text
                        // icon: Icons.lock,
                      ),

                      // Input field for confirm password
                      InputField(
                        label: 'Password',
                        hint: 'Confirm Password',
                        obscureText: true,
                        // icon: Icons.lock,
                      ),

                      const SizedBox(height: 20), // Space before button

                      // Register button
                      ElevatedBtn(
                        text: 'Register',
                        onPressed: () {
                          // TODO: Implement actual user registration logic here.
                          // On success, navigate to the main app screen.
                          Navigator.pushReplacementNamed(context, '/bottomnav');
                        },
                      ),
                    ],
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
