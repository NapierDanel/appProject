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
            stream: _dbService.streamPlaniantEventsFromFirebase(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return Column(children: <Widget>[
                SizedBox(height: 20),
                Text('Events'),
                SizedBox(height: 20),
                Container(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data.docs.map((data) {
                      return Container(
                        width: 300,
                        height: 100,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.amber,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.event, size: 70), ///TODO Add leading Event Icon
                                title: Text(data['planiantEventName'],
                                    style: TextStyle(color: Colors.blue)),
                                subtitle: Text(data['planiantEventDescription'],
                                    style: TextStyle(color: Colors.blue)),
                                //onTap: , ///TODO show Detail Event Screen
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ]);
            }));
  }
}
