import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:review_hub/CustomWidgets/customText.dart';
import 'package:review_hub/constants/colors.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getData() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('admin_notification').get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: maincolor,
              width: double.infinity,
              child: Center(child: AppText(text: 'Added Items', weight: FontWeight.w400, size: 20, textcolor: Colors.white)),
            ),
          ),
          Expanded(
            flex: 4,
            child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error fetching data"));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data![index].data() as Map<String, dynamic>;
                      return ListTile(
                        leading: CircleAvatar(backgroundImage: AssetImage('assets/images/profile.png')),
                        title: AppText(size: 15, text: data['name'] ?? 'No title', textcolor: Colors.black, weight: FontWeight.w500),
                        subtitle: AppText(size: 12, text: data['category'] ?? 'No content available', textcolor: Colors.black, weight: FontWeight.w400),
                        trailing: Text(data['date'] ?? 'No date'),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No notifications found"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
