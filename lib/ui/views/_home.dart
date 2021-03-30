import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_app_dev/services/dataclasses/_firebase_planiant_event.dart';
import 'package:provider/provider.dart';

import '_planiant_Event_Detail_Screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    /// Firebase PlaniantEvents
    List<PlaniantEvent> planiantEvents =
        Provider.of<List<PlaniantEvent>>(context);

    for(PlaniantEvent p in planiantEvents){
      print(p.planiantEventName);
    }

    return Scaffold(
        body: ListView.builder(
      itemCount: planiantEvents.length != null?planiantEvents.length : 0,
      itemBuilder: (context, index) {
        final planiantEvent = planiantEvents[index];
        return ListTile(
          title: Text(planiantEvent.planiantEventName),
          subtitle: Text(planiantEvent.planiantEventDescription),
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PlaniantEventDetailScreen(planiantEvent: planiantEvent)));

          },
        );
      },
    ));
  }

  Future<String> _getStoragePlaniantEventImageURL(String id) async {
    String planiantEventImagePath = 'PlaniantEventImages/' + id + '_titleImg';

    final ref = FirebaseStorage.instance.ref().child(planiantEventImagePath);

    var url = await ref.getDownloadURL();
    print('URL:' + url);
    return url;
  }
}



