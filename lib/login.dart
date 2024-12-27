import 'package:flutter/material.dart';
import 'package:lockboxx/controller/user_controller.dart';
import 'package:lockboxx/shared/login_form.dart';
import 'package:lockboxx/signup.dart';
import 'package:lockboxx/theme.dart';

import 'navigation.dart'; // Pastikan file navigation.dart diimpor

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});
  final formKey = GlobalKey<LogInFormState>();
  final UserController userController = UserController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 120),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'New to this app?',
                    style: subTitle,
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman sign up
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: textButton.copyWith(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1,
                          color: kBlackColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Form login
              LogInForm(
                key: formKey,
              ),
              const SizedBox(height: 20),
              // Tombol Login

              ElevatedButton(
                onPressed: () async {
                  final form = formKey.currentState;
                  if (form != null && form.validate()) {
                    final email = form.emailController.text;
                    final password = form.passwordController.text;
                    final user = await userController.login(email, password);
                    print(user?.name);
                    if (user != null) {
                      if (context.mounted) {
                        // Add a toast message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login successful'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MainPage(user: user), // Pass user to MainPage
                          ),
                        );
                      }
                    } else {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Login failed',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1B383A),
                  minimumSize: const Size(
                      400, 70), // Set the width and height of the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Border radius
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20, // Ukuran font
                    fontWeight: FontWeight.bold, // Membuat teks menjadi bold
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
