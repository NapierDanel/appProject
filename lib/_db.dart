import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_mobile_app_dev/data/_firebase_planiant_event.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addSampleEvent() {
    DatabaseReference _testRef =
        FirebaseDatabase.instance.reference().child("test");
    _testRef.set("Testvalue");
  }

  /// get a PlaniantEvent
  Future<PlaniantEvent> getPlaniantEvent(String id) async {
    var snap = await _db.collection('PlaniantEvent').doc(id).get();

    return PlaniantEvent.fromFirestore(snap);
  }

  /// Query a eventSubCollection
  Stream<List<PlaniantEvent>> streamPlaniantEvents(User user) {
    var ref =
        _db.collection('Users').doc(user.uid).collection('PlaniantEvent');

    return ref.snapshots().map(
        (list) => list.docs.map((event) => PlaniantEvent.fromFirestore(event)));
  }

  /// get a stream of a single PlaniantEvent
  Stream<PlaniantEvent> streamEvent(String id) {
    return _db
        .collection('PlaniantEvents')
        .doc(id)
        .snapshots()
        .map((event) => PlaniantEvent.fromFirestore(event));
  }

  /// stream a DataCollection from a given String
  Stream<QuerySnapshot> streamDataCollection() {
    return _db.collection('PlaniantEvent').snapshots();
  }
}
