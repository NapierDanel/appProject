import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  @override
  MyProfileStage createState() => MyProfileStage();
}



class MyProfileStage extends State<MyProfilePage> {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = await _auth.currentUser;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    if (_auth.currentUser != null) {
      print(_auth.currentUser.uid);

      return Text("Moin:" + FirebaseAuth.instance.currentUser.email);

    }

    return Text("Hallo");
  }
}
