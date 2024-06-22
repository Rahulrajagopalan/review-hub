import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:review_hub/CustomWidgets/customButton.dart';
import 'package:review_hub/CustomWidgets/customText.dart';
import 'package:review_hub/CustomWidgets/customTextField.dart';
import 'package:review_hub/constants/colors.dart';
import 'package:review_hub/user/homePage.dart';
import 'package:review_hub/user/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one digit';
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  Future<void> _onRegisterClick() async {
    if (_formKey.currentState?.validate() ?? false) {
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      try {
        await FirebaseFirestore.instance.collection('users').add({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'status': '0',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maincolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 250,
                color: Colors.white,
                child: Center(
                  child: AppText(
                    text: 'REVIEW HUB',
                    weight: FontWeight.w600,
                    size: 20,
                    textcolor: maincolor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Color.fromARGB(255, 8, 27, 133),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: AppText(
                            text: 'REGISTER',
                            weight: FontWeight.w600,
                            size: 20,
                            textcolor: white,
                          ),
                        ),
                        _buildTextField('Name', nameController, false),
                        _buildTextField('Email Address', emailController, false),
                        _buildTextField('Password', passwordController, true),
                        _loginPrompt(context),
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: CustomButton(
                            btnname: 'Register',
                            btntheam: white,
                            textcolor: maincolor,
                            click: _onRegisterClick,
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

  Widget _buildTextField(String hint, TextEditingController controller, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
      child: CustomTextField(
        hint: hint,
        controller: controller,
        validator: isPassword ? validatePassword : (value) => value?.isEmpty ?? true ? 'Please enter $hint' : null,
        // obscureText: isPassword,
      ),
    );
  }

  Widget _loginPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            text: 'Already have an account? ',
            weight: FontWeight.w400,
            size: 14,
            textcolor: white,
          ),
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            ),
            child: AppText(
              text: 'Login',
              weight: FontWeight.w400,
              size: 14,
              textcolor: red,
            ),
          ),
        ],
      ),
    );
  }
}
