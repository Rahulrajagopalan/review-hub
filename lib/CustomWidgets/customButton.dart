import 'package:flutter/material.dart';
import 'package:review_hub/CustomWidgets/customText.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,         //Custom Button......
    required this.btnname,
    required this.btntheam,
    required this.textcolor,
    required this.click,
    this.height = 50,
    this.textsize = 16,
  });

  final String btnname;
  final Color btntheam;
  final Color textcolor;
  final double height;
  final double textsize;
  final void Function() click;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: click,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: btntheam,
        ),
        child: Center(
          child: AppText(
              text: btnname,
              textcolor: textcolor,
              size: textsize,
              weight: FontWeight.w700),
        ),
      ),
    );
  }
}
