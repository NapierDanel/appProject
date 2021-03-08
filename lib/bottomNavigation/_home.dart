import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_app_dev/_db.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DatabaseService _dbService = DatabaseService();
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: _dbService.streamDataCollection(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return ListView(
                scrollDirection: Axis.horizontal,
                children: snapshot.data.docs.map((data)
                {
                  return Text(data['planiantEventDescription']);
                }).toList(),
              );
            }));
  }
}
