import 'package:cloud_firestore/cloud_firestore.dart';

class PlaniantEvent {

  final String id;
  final String planiantEventName;
  final String planiantEventDescription;
  final String planiantEventBeginDate;
  final String planiantEventEndDate;
  final String planiantEventImg;
  final String planiantEventLocation;
  final String planiantEventLongitude;
  final String planiantEventLatitude;

  PlaniantEvent({this.planiantEventName, this.planiantEventDescription, this.planiantEventBeginDate,
      this.planiantEventEndDate, this.planiantEventImg, this.planiantEventLocation, this.planiantEventLongitude, this.planiantEventLatitude, this.id});

  factory PlaniantEvent.fromFirestore(DocumentSnapshot doc){

    Map data = doc.data();

    return PlaniantEvent(
      id: doc.id,
      planiantEventName: data['planiantEventName'] ?? 'No Name',
      planiantEventDescription : data['planiantEventDescription'] ?? 'No Idea',
      planiantEventBeginDate : data['planiantEventBeginDate'] ?? 'No Plan',
      planiantEventEndDate: data['planiantEventEndDate'] ?? 'No Plan',
      planiantEventImg: data['planiantEventImg'] ?? '',
      planiantEventLocation: data['planiantEventLocation'] ?? 'No Location',
      planiantEventLatitude: data['planiantEventLongitude'] ?? 'No Longitude',
      planiantEventLongitude: data['planiantEventLatitude'] ?? 'No Latitude',
    );
  }

}