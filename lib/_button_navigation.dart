import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_app_dev/data/_planiant_event.dart';
import 'package:provider/provider.dart';
import '_db.dart';

class ButtonNavigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ButtonNavigationState();
  }
}

class ButtonNavigationState extends State<ButtonNavigation> {
  int _selectedIndex = 0;
  static  TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    RaisedButton(
      onPressed: () {
        DatabaseReference _testRef =
        FirebaseDatabase.instance.reference().child("test");
        _testRef.set("TestvalueYEAH");

      },
      child: Text('Add Test to Database', style: TextStyle(fontSize: 20)),
    ),
    Text(

      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Create Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Group',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.blue,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
