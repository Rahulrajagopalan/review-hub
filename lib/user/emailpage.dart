import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:review_hub/CustomWidgets/customButton.dart';
import 'package:review_hub/CustomWidgets/customTextField.dart';
import 'package:review_hub/constants/colors.dart';
import 'package:review_hub/user/resetpage.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maincolor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              hint: 'Enter registered email id',
              controller: emailController,
              validator: (value) => value?.isEmpty ?? true ? 'Please enter email' : null,
            ),
            SizedBox(height: 20),
            CustomButton(
              btnname: 'Next',
              btntheam: white,
              textcolor: maincolor,
              click: () => checkEmailAndNavigate(),
            ),
          ],
        ),
      ),
    );
  }

  void checkEmailAndNavigate() async {
    final email = emailController.text;  // Make sure you're using the text from the controller
    if (email.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Please enter an email address."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (result.docs.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Reset(email:emailController.text)), // Assuming NextPage is defined
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("No registered user found with that email."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}