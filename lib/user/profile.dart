import 'package:flutter/material.dart';
import 'package:review_hub/CustomWidgets/customText.dart';
import 'package:review_hub/constants/colors.dart';
import 'package:review_hub/user/editProfile.dart';
import 'package:review_hub/user/help.dart';
import 'package:review_hub/user/login.dart';
import 'package:review_hub/user/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                maxRadius: 50,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
               Icon(Icons.edit_square),
               SizedBox(width: 10,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return EditProfile();
                    },));
                  },
                  child: AppText(text: 'Edit Profile', weight: FontWeight.w500, size: 18, textcolor: customBalck)),
              ],
            ),
          ),
          //  Padding(
          //   padding: const EdgeInsets.all(18.0),
          //   child: Row(
          //     children: [
          //      Icon(Icons.notifications),
          //      SizedBox(width: 10,),
          //       InkWell(
          //         onTap: (){
          //           Navigator.push(context, MaterialPageRoute(builder: (context) {
          //             return Notifications();
          //           },));
          //         },
          //         child: AppText(text: 'Notifications', weight: FontWeight.w500, size: 18, textcolor: customBalck)),
          //     ],
          //   ),
          // ),
           Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
               Icon(Icons.help),
               SizedBox(width: 10,),
                InkWell(
                    onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Help();
                    },));
                  },
                  child: AppText(text: 'Help and Support', weight: FontWeight.w500, size: 18, textcolor: customBalck)),
              ],
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
               Icon(Icons.power_settings_new),
               SizedBox(width: 10,),
                InkWell(
                    onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return HomeScreen();
                    },)); 
                  },
                  child: AppText(text: 'Logout', weight: FontWeight.w500, size: 18, textcolor: customBalck)),
              ],
            ),
          )
        ],
      ),
    );
  }
}