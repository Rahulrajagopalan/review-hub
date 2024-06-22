import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:review_hub/CustomWidgets/customButton.dart';
import 'package:review_hub/CustomWidgets/customText.dart';
import 'package:review_hub/constants/colors.dart';
import 'package:review_hub/user/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
   TextEditingController? name;
   TextEditingController? email;
   TextEditingController? mobile;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    var id = spref.getString('id') ?? '';
    var nm = spref.getString('name') ?? '';
    var em = spref.getString('email') ?? '';
    var ps = spref.getString('password') ?? '';
    setState(() {
      name = TextEditingController(text: nm);
    email = TextEditingController(text: em);
    mobile = TextEditingController(text: ps);
    });
    
  }

  Future<void> edit() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
 var id = spref.getString('id') ?? '';
    var nm = name!.text;
    var em = email!.text;
    var ps = mobile!.text;


        spref.setString('name', nm);
        spref.setString('email', em);
        spref.setString('password', ps);

    FirebaseFirestore.instance.collection('users').doc(id).update({
    'name': nm,
    'email': em,
    'password':ps
  }).then((value) {
    print("User Updated");
     Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
  }).catchError((error) {
    print("Failed to update user: $error");
  });
    // Perform your edit operations here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: AppText(
          text: 'Edit Profile',
          weight: FontWeight.w500,
          size: 20,
          textcolor: white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.png'),
              radius: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28, right: 28, top: 28),
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: name,
                decoration: InputDecoration(
                  errorBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  fillColor: maincolor,
                  filled: true,
              
                  hintStyle: TextStyle(color: white),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28, right: 28, top: 10),
              child: TextFormField(
                controller: email,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  errorBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  fillColor: maincolor,
                  filled: true,
              
                  hintStyle: TextStyle(color: white),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28, right: 28, top: 28),
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: mobile,
                decoration: InputDecoration(
                  errorBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  fillColor: maincolor,
                  filled: true,
               
                  hintStyle: TextStyle(color: white),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: CustomButton(
                  btnname: 'Save',
                  btntheam: maincolor,
                  textcolor: white,
                  click: () {
                    edit();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
