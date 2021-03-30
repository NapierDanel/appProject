import 'package:flutter/foundation.dart';
import 'package:flutter_application_mobile_app_dev/services/dataclasses/_firebase_planiant_event.dart';
import 'package:flutter_application_mobile_app_dev/services/service_locator.dart';

/// The UI listen for changes in the View Model
/// [ChangeNotifier] provides notifyListener()
class HomeViewModel extends ChangeNotifier{

  /// service handles saving and exchange events
  //final PlaniantEventService _planiantEventService = serviceLocator<PlaniantEventService>();

  List<PlaniantEvent> _planiantEvents = [];
  List<PlaniantEvent> _favorites = [];

  List<PlaniantEvent> get planiantEvents => _planiantEvents;

  void loadData() async{
   // final planiantEvents = await _planiantEventService.getAllPlaniantEvents();
    //_favorites = await _planiantEventService.getFavoritePlaniantEvents();

    notifyListeners();
  }

   void toggleFavoriteStatus(int choiceIndex) {

    notifyListeners();
  }

  void _prepareChoicePresentation(List<PlaniantEvent> planiantEvents){
    List<PlaniantEvent> list = [];
    for(PlaniantEvent planiantEvent in _planiantEvents){

    }

  }

}

class PlaniantEventPresentation{
  final String name;
  final String description;
  bool isFavorite;

  PlaniantEventPresentation({
      this.name, this.description, this.isFavorite});

}