import 'package:excelerate_intern_app/widgets/elevated_btn.dart';
import 'package:excelerate_intern_app/widgets/input_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();

    void login() {
      if (email.text == 'admin@gmail.com' && password.text == 'admin123') {
        Navigator.pushReplacementNamed(context, '/bottomnav');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Level up',style:TextStyle(fontSize: 32,fontWeight: FontWeight.w700)),centerTitle: true,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // This will center the login form vertically
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // So it doesn't expand
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                      InputField(
                        label: 'Email',
                        hint: 'Enter your email',
                        icon: Icons.mail_sharp,
                        controller: email,
                      ),

                      InputField(
                        label: 'Password',
                        hint: 'Enter your password',
                        obscureText: true,
                        icon: Icons.lock,
                        controller: password,
                      ),

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

              // Bottom "Register now" text
              Center(
                child: GestureDetector(
                  onTap: () {
                    // print('Navigate to Register Page');
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
