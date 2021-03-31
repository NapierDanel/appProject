import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_mobile_app_dev/data/_firebase_planiant_event.dart';

class PlaniantUser {
  String id;
  String email;
  String userName;

  String imgPath;

  List<String> acceptedPlaniantEvents;
  List<String> organizedPlaniantEvents;

  PlaniantUser(
      {this.id,
      this.email,
      this.userName,
      this.imgPath,
      this.acceptedPlaniantEvents,
      this.organizedPlaniantEvents});

  /// The current User
  static PlaniantUser planiantUser = PlaniantUser();

  /// singleton
  static PlaniantUser getPlaniantUserInstance() {
    if (planiantUser == null) {
      planiantUser = PlaniantUser();
      return planiantUser;
    } else {
      return planiantUser;
    }
  }

  /// User Collection
  static final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  static initPlaniantUser(String userId) async {
    PlaniantUser.planiantUser.id = userId;
    print("User: " + userId);
    var rawUser = await _usersCollectionReference.doc(userId).get();

    PlaniantUser.fromData(rawUser.data());
    print(PlaniantUser.getPlaniantUserInstance().toJson());
  }

  static createPlaniantUser(
      String emailInput, String passwordInput, String userNameInput) async {
    print("createPlaniantUser: " + emailInput + passwordInput);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailInput, password: passwordInput);

      getPlaniantUserInstance().email = emailInput;
      getPlaniantUserInstance().userName = userNameInput;
      getPlaniantUserInstance().id = userCredential.user.uid;
      getPlaniantUserInstance().organizedPlaniantEvents = List<String>();
      getPlaniantUserInstance().organizedPlaniantEvents.add("initParty");
      getPlaniantUserInstance().acceptedPlaniantEvents = List<String>();
      getPlaniantUserInstance().acceptedPlaniantEvents.add("initParty");
      print("Created: " + emailInput);

      _usersCollectionReference
          .doc(userCredential.user.uid)
          .set(planiantUser.toJson());

      print(planiantUser.toJson());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  updateUserImagePath(String path){
    PlaniantUser.getPlaniantUserInstance().imgPath = path;
    _usersCollectionReference
        .doc(getPlaniantUserInstance().id)
        .update(planiantUser.toJson());
  }

  addAcceptPlaniantEvent(String id) {
    print(id);

    if(!PlaniantUser.getPlaniantUserInstance().acceptedPlaniantEvents.contains(id)){
      PlaniantUser.getPlaniantUserInstance().acceptedPlaniantEvents.add(id);
    }

    _usersCollectionReference
        .doc(getPlaniantUserInstance().id)
        .update(planiantUser.toJson());
  }

  removeAcceptPlaniantEvent(String id){
    if(PlaniantUser.getPlaniantUserInstance().acceptedPlaniantEvents.contains(id)){
      PlaniantUser.getPlaniantUserInstance().acceptedPlaniantEvents.remove(id);
    }

    _usersCollectionReference
        .doc(getPlaniantUserInstance().id)
        .update(planiantUser.toJson());

  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'acceptedPlaniantEvents': acceptedPlaniantEvents,
      'organizedPlaniantEvents': organizedPlaniantEvents,
    };
  }

  PlaniantUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        userName = data['userName'],
        email = data['email'],
        imgPath = data['imgPath'] ?? 'No image path',
        acceptedPlaniantEvents = List.from(data['acceptedPlaniantEvents']) ?? 'No events',
        organizedPlaniantEvents =
            List.from(data['organizedPlaniantEvents']) ?? 'No events';
}
