import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:review_hub/constants/colors.dart';
import 'package:review_hub/user/home.dart';
import 'package:review_hub/user/notification.dart';
import 'package:review_hub/user/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  var itemController = TextEditingController();
  var descriptionController = TextEditingController();
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Notifications(),
    Profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        actions: [
          IconButton(
              onPressed: () {
                // Request for new review
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Request For review'),
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Column(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    controller: itemController,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Please enter comment';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      fillColor: grey,
                                      filled: true,
                                      hintText: 'Enter Item name',
                                      hintStyle: TextStyle(color: Colors.white),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: white),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: white),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    maxLines: 5,
                                    maxLength: 50,
                                    controller: descriptionController,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Please enter comment';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      fillColor: grey,
                                      filled: true,
                                      hintText: 'Description for the product',
                                      hintStyle: TextStyle(color: Colors.white),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: white),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: white),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: white),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 5),
                                  child: InkWell(
                                    onTap: () async {
                                      SharedPreferences spref =
                                          await SharedPreferences.getInstance();
                                      var name = spref.getString('name');
                                      DateTime now = DateTime.now();
                                      DateFormat formatter =
                                          DateFormat('dd-MM-yyyy');
                                      String formattedDate =
                                          formatter.format(now);

                                          await FirebaseFirestore.instance
                                              .collection('request')
                                              .add({
                                        'user': name,
                                        'request': itemController.text,
                                        'description':
                                            descriptionController.text,
                                        'date': formattedDate,
                                      });

                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      color: maincolor,
                                      height: 35,
                                      width: 100,
                                      child: const Center(
                                        child: Text(
                                          'Send request',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ));
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       UserAccountsDrawerHeader(
      //         accountName: Text("User Name"),
      //         accountEmail: Text("user@example.com"),
      //         currentAccountPicture: CircleAvatar(
      //           backgroundColor: Colors.orange,
      //           child: Text(
      //             "A",
      //             style: TextStyle(fontSize: 40.0),
      //           ),
      //         ),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.home),
      //         title: Text('Home'),
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.notifications),
      //         title: Text('notification'),
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.settings),
      //         title: Text('Settings'),
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //     ],
      //   ),

      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: maincolor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
            backgroundColor: maincolor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: maincolor,
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 250, 242, 242),
        iconSize: 40,
        onTap: _onItemTapped,
        elevation: 5,
      ),
    );
  }
}
