import 'package:flutter/cupertino.dart';
import 'package:flutter_application_mobile_app_dev/init/my_app.dart';
import 'package:provider/provider.dart';
import '_db.dart';
import '../bottomNavigation/_home.dart';

import 'package:flutter_application_mobile_app_dev/data/_firebase_planiant_event.dart';

class Root extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    final DatabaseService databaseService = DatabaseService();

    return StreamProvider<List<PlaniantEvent>>.value(value: databaseService.planiantEvents, child: MyApp());
  }

}