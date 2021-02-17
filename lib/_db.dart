import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_mobile_app_dev/data/_planiant_event.dart';


class DatabaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addSampleEvent(){
    DatabaseReference _testRef = FirebaseDatabase.instance.reference().child("test");
    _testRef.set("Testvalue");
  }

  /// get a PlaniantEvent
  Future<PlaniantEvent> getPlaniantEvent(String id) async {
    var snap = await _db.collection('PlaniantEvents').doc(id).get();
    
    return PlaniantEvent.fromFirestore(snap);
  }


  /// Query a eventSubCollection
  Stream<List<PlaniantEvent>> streamPlaniantEvents(User user){
    var ref = _db.collection('Users').doc(user.uid).collection('PlaniantEvents');

    return ref.snapshots().map((list) =>
        list.docs.map((docs) => PlaniantEvent.fromFirestore(docs)));
  }



}