import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_mobile_app_dev/data/_firebase_planiant_event.dart';

class FirebasePlaniantEventDecoder {

  Map<String, PlaniantEvent> getFirebaseEvents() {
    Map<String, PlaniantEvent> firebaseEventMap;

    FirebaseFirestore.instance
        .collection('PlaniantEvents')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                firebaseEventMap.putIfAbsent(
                    doc['id'],
                    () => new PlaniantEvent(
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

    return firebaseEventMap;
  }

/*Map<String,PlaniantEvent> getFirebaseEventsByLocationName(String locationName){
    var firebasePlaniantEvents = FirebaseFirestore.instance.collection('PlaniantEvents');

    firebasePlaniantEvents.where()


    }
  }*/
}
