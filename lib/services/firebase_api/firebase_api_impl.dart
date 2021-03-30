import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_mobile_app_dev/services/dataclasses/_firebase_planiant_event.dart';
import 'package:flutter_application_mobile_app_dev/services/dataclasses/_user.dart';
import 'package:flutter_application_mobile_app_dev/services/firebase_api/firebase_api.dart';

class FirebaseApiImpl implements FirebaseApi {

  /// Firebase Database
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  /// Firebase User
  final User currentUser = FirebaseAuth.instance.currentUser;

  /// Fetch all PlaniantEvents from Firebase
  @override
  Future<List<PlaniantEvent>> fetchPlaniantEvents() async {
    List<PlaniantEvent> planiantEvents = [];

    _database.collection('PlaniantEvents').get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; i++) {
          print(docs.docs[i].id);
          planiantEvents.add(_getPlaniantEvent(docs.docs[i], docs.docs[i].id));
        }
      }
    });

    return planiantEvents;
  }

  PlaniantEvent _getPlaniantEvent(rawPlaniantEvent, String planiantEventId) {
    final planiantEventNameString =
        rawPlaniantEvent.get('planiantEventName').toString();
    final planiantEventDescriptionString =
        rawPlaniantEvent.get('planiantEventDescription').toString();
    final planiantEventBeginDateString =
        rawPlaniantEvent.get('planiantEventBeginDate').toString();
    final planiantEventEndDateString =
        rawPlaniantEvent.get('planiantEventEndDate').toString();
    final planiantEventImgString =
        rawPlaniantEvent.get('planiantEventImg').toString();
    final planiantEventLocationString =
        rawPlaniantEvent.get('planiantEventLocation').toString();
    final planiantEventLatitudeString =
        rawPlaniantEvent.get('planiantEventLatitude').toString();
    final planiantEventLongitudeString =
        rawPlaniantEvent.get('planiantEventLongitude').toString();

    PlaniantEvent planiantEvent = new PlaniantEvent(
        planiantEventName: planiantEventNameString,
        planiantEventDescription: planiantEventDescriptionString,
        planiantEventBeginDate: planiantEventBeginDateString,
        planiantEventEndDate: planiantEventEndDateString,
        planiantEventLocation: planiantEventLocationString,
        planiantEventLongitude: planiantEventLongitudeString,
        planiantEventLatitude: planiantEventLatitudeString,
        id: planiantEventId);

    return planiantEvent;
  }

  @override
  Future<PlaniantUser> fetchPlaniantUser() async {
    return PlaniantUser.getPlaniantUserInstance();
  }
}
