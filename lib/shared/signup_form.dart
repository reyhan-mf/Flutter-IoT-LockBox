import 'package:flutter/material.dart';
import 'package:lockboxx/theme.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  bool _isObscure = true;
  
  // Add controllers for form fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildInputForm('Your Name', false, nameController),
          buildInputForm('Email', false, emailController),
          buildInputForm('Phone', false, phoneController),
          buildInputForm('Password', true, passwordController),
          buildInputForm('Confirm Password', true, confirmPasswordController),
        ],
      ),
    );
  }

  Padding buildInputForm(String hint, bool pass, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: pass ? _isObscure : false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hint is required';
          }
          if (pass && hint == 'Confirm Password' && 
              value != passwordController.text) {
            return 'Passwords do not match';
          }
          if (hint == 'Email' && !value.contains('@')) {
            return 'Please enter a valid email';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: kTextFieldColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          suffixIcon: pass
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                    color: _isObscure ? kTextFieldColor : kPrimaryColor,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}