import 'package:flutter/material.dart';
import '_button_navigation.dart';
import 'package:flutter_application_mobile_app_dev/_event_drawer.dart';


class MyApp extends StatelessWidget {
  final appTitle = 'Event App';

  @override
  Widget build(BuildContext contexMyAppt) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
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
