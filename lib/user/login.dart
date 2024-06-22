import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:review_hub/CustomWidgets/customButton.dart';
import 'package:review_hub/CustomWidgets/customText.dart';
import 'package:review_hub/CustomWidgets/customTextField.dart';
import 'package:review_hub/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homePage.dart';
import 'register.dart';
import 'emailpage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final QuerySnapshot<Map<String, dynamic>> customerSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: emailController.text)
              .where('password', isEqualTo: passwordController.text)
              .get();

      if (customerSnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful')),
        );

        String userId = customerSnapshot.docs[0].id;
        String name = customerSnapshot.docs[0]['name'];
        String email = customerSnapshot.docs[0]['email'];
        String password = customerSnapshot.docs[0]['password'];

        SharedPreferences spref = await SharedPreferences.getInstance();
        spref.setString('id', userId);
        spref.setString('name', name);
        spref.setString('email', email);
        spref.setString('password', password);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maincolor,
      body: SafeArea(
        child: Stack(
          children: [
            const Expanded(
              child: _HeaderSection(),
            ),
            Expanded(
              flex: 3,
              child: _LoginSection(
                formKey: _formKey,
                emailController: emailController,
                passwordController: passwordController,
                onLogin: login,
                validatePassword: validatePassword,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: maincolor,
      child: Center(
        child: AppText(
          text: 'REVIEW HUB',
          weight: FontWeight.w600,
          size: 20,
          textcolor: maincolor,
        ),
      ),
    );
  }
}

class _LoginSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function onLogin;
  final String? Function(String?) validatePassword;

  const _LoginSection({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    required this.validatePassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
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
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Color.fromARGB(255, 8, 27, 133),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    _buildLoginText(context),
                    _buildTextField(context, 'Email Address', emailController, false),
                    _buildTextField(context, 'Password', passwordController, true),
                    _buildForgotPassword(context),
                    _buildLoginButton(context),
                    _buildCreateAccount(context),
                    _buildGoogleSignIn(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding _buildLoginText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: AppText(
        text: 'LOGIN',
        weight: FontWeight.w600,
        size: 20,
        textcolor: white,
      ),
    );
  }

  Padding _buildTextField(
      BuildContext context, String hint, TextEditingController controller, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, right: 28, left: 28),
      child: CustomTextField(
        hint: hint,
        controller: controller,
        validator: isPassword ? validatePassword : (value) => value?.isEmpty ?? true ? 'Please enter $hint' : null,
        // obscureText: isPassword,
      ),
    );
  }

  Padding _buildForgotPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EmailPage();
          },));
        },
        child: AppText(
          text: 'Forgot Password',
          weight: FontWeight.w400,
          size: 12,
          textcolor: red,
        ),
      ),
    );
  }

  Padding _buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: CustomButton(
        btnname: 'Login',
        btntheam: white,
        textcolor: maincolor,
        click: () => onLogin(),
      ),
    );
  }

  Padding _buildCreateAccount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => Register())),
        child: AppText(
          text: 'Create account',
          weight: FontWeight.w400,
          size: 12,
          textcolor: red,
        ),
      ),
    );
  }

  Widget _buildGoogleSignIn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 30,
          child: Image.asset('assets/images/google.png'),
        ),
        InkWell(
          onTap: () {
            _loginWithGoogle(context);
          },
          child: AppText(
            text: 'Sign in with Google',
            weight: FontWeight.w400,
            size: 12,
            textcolor: white,
          ),
        ),
      ],
    );
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with Google: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
