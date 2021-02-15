import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'drawer/_settings.dart';

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
            // leading: Icon(Icons.),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
          ListTile(
            title: Text('Login'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
        ],
      ),
    );
  }

}