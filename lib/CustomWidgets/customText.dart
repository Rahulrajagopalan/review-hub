import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  const AppText(        //Custom Text Widget.....
      {super.key,
      required this.text,
      required this.weight,
      required this.size,
      required this.textcolor});

  final String text;
  final FontWeight weight;
  final double size;
  final Color textcolor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          fontSize: size, color: textcolor,
          fontWeight: weight),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}
