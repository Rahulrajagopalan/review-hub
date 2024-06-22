import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:review_hub/CustomWidgets/customButton.dart';
import 'package:review_hub/CustomWidgets/customTextField.dart';
import 'package:review_hub/constants/colors.dart';
import 'package:review_hub/user/login.dart';

class Reset extends StatefulWidget {
  String email;
  Reset({super.key, required this.email});

  @override
  State<Reset> createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maincolor,
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              hint: 'Enter new password',
              controller: passwordController,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter email' : null,
            ),
            SizedBox(height: 20),
            CustomButton(
                btnname: 'Next',
                btntheam: white,
                textcolor: maincolor,
                click: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: widget.email)
                      .get()
                      .then((querySnapshot) {
                    if (querySnapshot.docs.isNotEmpty) {
                      querySnapshot.docs.first.reference.update({
                        'password': passwordController
                            .text // Storing passwords in plain text is bad practice!
                      }).then((_) {
                        _showDialog('Password Reset',
                            'Your password has been successfully reset.');
                      }).catchError((error) {
                        _showDialog(
                            'Error', 'Failed to update password: $error');
                      });
                    } else {
                      _showDialog('Error', 'No user found with this email.');
                    }
                  });
                }),
          ],
        ),
      ),
    );
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () =>
                Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            )),
          ),
        ],
      ),
    );
  }
}
