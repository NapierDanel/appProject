import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_mobile_app_dev/data/_user.dart';
import 'package:flutter_application_mobile_app_dev/init/my_app.dart';
import 'package:provider/provider.dart';
import '../data/_db.dart';
import 'package:flutter_application_mobile_app_dev/data/_firebase_planiant_event.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    if (FirebaseAuth.instance.currentUser != null) {
      print("init Planiant user");
      PlaniantUser.initPlaniantUser(FirebaseAuth.instance.currentUser.uid);
    }

    return StreamProvider<List<PlaniantEvent>>.value(
        value: databaseService.planiantEvents, initialData: [], child: MyApp());
  }
}
