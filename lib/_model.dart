import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_mobile_app_dev/_db.dart';

class Model extends ChangeNotifier {
  DatabaseService _db = DatabaseService();

  Stream<QuerySnapshot> fetchPlaniantEventsAsStream() {
    notifyListeners();
    return _db.streamPlaniantEventsFromFirebase();
  }
}
