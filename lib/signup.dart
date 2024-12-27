import 'package:flutter/material.dart';
import 'package:lockboxx/controller/user_controller.dart';
import 'package:lockboxx/login.dart';
import 'package:lockboxx/navigation.dart';
import 'package:lockboxx/services/api_services.dart';
import 'package:lockboxx/shared/signup_form.dart';
import 'package:lockboxx/theme.dart';

class SignUpScreen extends StatelessWidget {
  final ApiService apiService = ApiService(); // Create instance of ApiService
  final UserController userController = UserController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a GlobalKey to access the form state
    final formKey = GlobalKey<SignUpFormState>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            const Padding(
              padding: kDefaultPadding,
              child: Text('Create Account',
                  style: TextStyle(
                      color: kBlackColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: kDefaultPadding,
              child: Row(
                children: [
                  Text('Already a member?', style: subTitle),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LogInScreen()));
                    },
                    child: Text(
                      'Log In',
                      style: textButton.copyWith(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1,
                          color: kBlackColor),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: kDefaultPadding,
              child: SignUpForm(key: formKey),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  final form = formKey.currentState;
                  if (form != null && form.validate()) {
                    try {
                      final response = await apiService.register(
                        name: form.nameController.text,
                        email: form.emailController.text,
                        phone: form.phoneController.text,
                        password: form.passwordController.text,
                      );

                      print(response);
                      if (response['success'] == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email is already registered'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Registration successful!'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        final email = form.emailController.text;
                        final password = form.passwordController.text;
                        final user =
                            await userController.login(email, password);
                        if (user != null) {
                          print(user.name);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPage(
                                user: user,
                              ),
                            ),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LogInScreen()),
                          );
                        }
                      }

                      // Navigate to login screen after successful registration
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1B383A),
                  minimumSize: const Size(350, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
