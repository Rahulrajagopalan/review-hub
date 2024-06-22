import 'package:flutter/material.dart';
import 'package:review_hub/constants/colors.dart';
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.hint,
    this.kebordtype = TextInputType.text,
    required this.controller,
    required this.validator,
    this.obscure = false,
    this.fillcolor = white,
    this.readonly = false,
  }) : super(key: key);

  final String hint;
  final TextInputType kebordtype;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscure;
  final bool readonly;
  final Color fillcolor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 15),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscure,
        style: TextStyle(color: Colors.white),
        readOnly: readonly,
        decoration: InputDecoration(
          errorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
          // fillColor: fillcolor,
          filled: false,
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: white),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: white),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: white),
          ),
        ),
      ),
    );
  }
}
