import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '_button_navigation.dart';
import 'package:flutter_application_mobile_app_dev/_event_drawer.dart';


class MyApp extends StatelessWidget {
  final appTitle = 'Event App';
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext contexMyAppt) {
    return MaterialApp(
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
    );
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
