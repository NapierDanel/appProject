import 'package:flutter_application_mobile_app_dev/data/_firebase_planiant_event.dart';

class User{

  String id;
  String firstName;
  String lastName;

  String imgPath;

  List<PlaniantEvent> acceptPlaniantEvents;
  List<PlaniantEvent> createdPlaniantEvents;

  User(this.id, this.firstName, this.lastName, this.imgPath);

}