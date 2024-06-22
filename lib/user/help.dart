import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:review_hub/CustomWidgets/customText.dart';
import 'package:review_hub/constants/colors.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Container(
            color: maincolor,
            width: double.infinity,
            child: Center(
                child: AppText(
                    text: 'Help & Support',
                    weight: FontWeight.w400,
                    size: 20,
                    textcolor: white)),
          )),
          Expanded(
              flex: 4,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    child: SizedBox(
                        child: Text(
'At Review Hub, we are dedicated to providing you with a seamless and enjoyable experience as you explore and engage with our vast collection of movie reviews and ratings. Whether you are encountering a technical issue, need help navigating our app, or have questions about your account, our Support Center is here to assist you.At Review Hub, your experience is our top priority. Don’t hesitate to reach out with any issues or questions — we’re here to ensure that your journey with us is smooth and enjoyable.Understand the dos and donts to ensure a safe and respectful environment for all users.Send us your queries or concerns at support@reviewhub.com. Our team will respond within 24-48 hours.',style: GoogleFonts.poppins(fontSize: 15, )),
                    )),
                  ),
                ),
              )
        ],
      ),
    );
  }
}
