import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_app_dev/drawer/_login.dart';
import 'package:flutter_application_mobile_app_dev/drawer/_my_profile.dart';

import '_settings.dart';

class EventDrawer extends StatelessWidget {





  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Planiant'),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: new DecorationImage(
                image: AssetImage('assets/images/drawerHeaderImg.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: Text('My Profile'),
            leading: Icon(Icons.account_circle_outlined),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyProfilePage()));
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
          ListTile(
            title: Text('Login'),
            leading: Icon(Icons.login),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.logout),
            onTap: () {
              _logout();
              final snackBar = SnackBar(
                content: Text('Logged out'),

              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

            },
          ),

    ],
      ),
    );

  }

  _logout() async {
    await FirebaseAuth.instance.signOut();
    print('User logged out');
  }
}
