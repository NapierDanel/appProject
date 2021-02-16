import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addSampleEvent(){
    DatabaseReference _testRef = FirebaseDatabase.instance.reference().child("test");
    _testRef.set("Testvalue");
  }

}