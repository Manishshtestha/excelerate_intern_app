import 'package:flutter/material.dart';
import 'package:excelerate_intern_app/widgets/elevated_btn.dart';
import 'package:excelerate_intern_app/widgets/input_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Level up',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // So it doesn't expand
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                      const SizedBox(height: 40),
                      InputField(
                        label: 'Full Name',
                        hint: 'Full Name',
                        // icon: Icons.mail_sharp,
                      ),
                      
                      InputField(
                        label: 'Email',
                        hint: 'Email',
                        // icon: Icons.mail_sharp,
                      ),

                      InputField(
                        label: 'Password',
                        hint: 'Password',
                        obscureText: true,
                        // icon: Icons.lock,
                      ),
                      InputField(
                        label: 'Password',
                        hint: 'Confirm Password',
                        obscureText: true,
                        // icon: Icons.lock,
                      ),

                      SizedBox(height: 20),
                      ElevatedBtn(
                        text: 'Register',
                        onPressed: () {
                          print('Logging in');
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
