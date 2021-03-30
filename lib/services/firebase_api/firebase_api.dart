import 'package:flutter_application_mobile_app_dev/services/dataclasses/_user.dart';

import '../dataclasses/_firebase_planiant_event.dart';

abstract class FirebaseApi{

  Future<List<PlaniantEvent>> fetchPlaniantEvents();
  Future<PlaniantUser> fetchPlaniantUser();
  
}
