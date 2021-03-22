import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_mobile_app_dev/data/_firebase_planiant_event.dart';

class FirebasePlaniantEventDecoder {

  static Map<String, PlaniantEvent> planiantEvents;
  final FirebaseFirestore _database = FirebaseFirestore.instance;


  void getFirebaseEvents() {

      FirebaseFirestore.instance
          .collection('PlaniantEvents')
          .get()
          .then((QuerySnapshot querySnapshot) =>
      {
        querySnapshot.docs.forEach((doc) {
          planiantEvents.putIfAbsent(
              doc['id'],
                  () =>
              new PlaniantEvent(
                planiantEventDescription:
                doc['planiantEventDescription'].toString(),
                planiantEventBeginDate:
                doc['planiantEventBeginDate'].toString(),
                planiantEventEndDate:
                doc['planiantEventEndDate'].toString(),
                planiantEventImg: doc['planiantEventImg'].toString(),
                planiantEventLocation:
                doc['planiantEventLocation'].toString(),
                planiantEventLongitude:
                doc['planiantEventLongitude'].toString(),
                planiantEventLatitude:
                doc['planiantEventLatitude'].toString(),
                id: doc['id'].toString(),
              ));
        })
      });

      for(PlaniantEvent e in planiantEvents.values){
        print(e);
      }

    }


  void addPlaniantEventToPlaniantEventsMap(PlaniantEvent planiantEvent) {

  }

/*Map<String,PlaniantEvent> getFirebaseEventsByLocationName(String locationName){
    var firebasePlaniantEvents = FirebaseFirestore.instance.collection('PlaniantEvents');

    firebasePlaniantEvents.where()


    }
  }*/
}
