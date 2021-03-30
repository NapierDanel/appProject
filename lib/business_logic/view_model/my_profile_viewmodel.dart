import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_mobile_app_dev/services/dataclasses/_firebase_planiant_event.dart';
import 'package:flutter_application_mobile_app_dev/services/dataclasses/_user.dart';
import 'package:flutter_application_mobile_app_dev/services/firebase_api/firebase_api.dart';
import 'package:flutter_application_mobile_app_dev/services/service_locator.dart';

/// The UI listen for changes in the View Model
/// [ChangeNotifier] provides notifyListener()
class MyProfileViewModel extends ChangeNotifier {

  @override
  void dispose() {

  }
  /// service handles saving and exchange events
  final FirebaseApi _planiantEventService =
      serviceLocator<FirebaseApi>();
 
  List<PlaniantEvent> _planiantEvents = [];
  List<PlaniantEventPresentation> _favorites = [];
  List<PlaniantEventPresentation> _accept_meetings = [];
  User _currentFirebaseUser;
  PlaniantUser _currentPlaniantUser;

  List<PlaniantEvent> get planiantEvents => _planiantEvents;
  List<PlaniantEventPresentation> get favPlaniantEvents => _favorites;
  User get currentFirebaseUser => _currentFirebaseUser;
  PlaniantUser get currentPlaniantUser => currentPlaniantUser;

  void loadData() async {
    final planiantEvents = await _planiantEventService.fetchPlaniantEvents();
    _currentFirebaseUser = FirebaseAuth.instance.currentUser;
    _currentPlaniantUser = PlaniantUser.getPlaniantUserInstance();
    _preparePlaniantEventPresentation(planiantEvents);
    notifyListeners();
  }

  void _preparePlaniantEventPresentation(List<PlaniantEvent> planiantEvents) {
    List<PlaniantEventPresentation> list = [];

    for (PlaniantEvent planiantEvent in _planiantEvents) {
      if(_currentPlaniantUser.acceptedPlaniantEvents.contains(planiantEvent.id)) {
        String planiantEventId = planiantEvent.id;
        list.add(PlaniantEventPresentation(
            name: planiantEvent.planiantEventName,
            description: planiantEvent.planiantEventDescription,
            id: planiantEventId));
      }
    }
    _favorites = list;
  }
}

class PlaniantEventPresentation {
  final String name;
  final String description;
  final String id;

  PlaniantEventPresentation({this.name, this.description, this.id});
}
