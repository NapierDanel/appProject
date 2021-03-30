import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_app_dev/data/_db.dart';
import 'package:flutter_application_mobile_app_dev/data/_firebase_planiant_event.dart';
import '../bottomNavigation/_bottom_navigation.dart';
import 'package:flutter_application_mobile_app_dev/drawer/_event_drawer.dart';
import 'package:provider/provider.dart';


class MyApp extends StatelessWidget {
  final appTitle = 'Event App';
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  final db = DatabaseService();


  @override
  Widget build(BuildContext contexMyAppt) {
    return MultiProvider(

      /// setup streams and share them without having nest widgets
        providers: [

          /// Observe the planiantEvents
          StreamProvider<List<PlaniantEvent>>.value(
            value: DatabaseService().planiantEvents,
            child: MyApp(),
          )

        ],
        child: MaterialApp(
          title: appTitle,
          home: FutureBuilder(
            future: _fbApp,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('Here is an Error! ${snapshot.error.toString()}');
                return Text('Something went wrong');
              } else if (snapshot.hasData) {
                return MyHomePage(title: appTitle);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: EventDrawer(),
      body: ButtonNavigation(),
    );
  }
}

