import 'package:flutter/material.dart';
import 'package:review_hub/constants/colors.dart';
import 'package:review_hub/user/home.dart';
import 'package:review_hub/user/notification.dart';
import 'package:review_hub/user/profile.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
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
