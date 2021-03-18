import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import '../_create_event_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:map_controller/map_controller.dart';

import '../_db.dart';

class EventMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FireMap(),
    );
  }
}

class FireMap extends StatefulWidget {
  State createState() => FireMapState();
}

class FireMapState extends State<FireMap> {
  GoogleMapController mapController;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  Location location = new Location();

  /// PlaniantEvents
  BehaviorSubject<double> radius = BehaviorSubject();
  Stream<dynamic> query;

  /// Subscription
  StreamSubscription subscription;

  LatLng currentPosition;

  @override
  void initState() {
    _getUserLocation();
    super.initState();
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(47.72674, 10.31389),
            zoom: 15,
          ),
          myLocationEnabled: true,
          mapType: MapType.satellite,
        ),
        Positioned(
          bottom: 25,
          right: 10,
          height: 50,
          width: 50,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.amber,
              ),
              onPressed: () {},
            ),
          ),
        )
      ],
    );
  }

  showPlaniantEvents() {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    _db.collection('PlaniantEvents').get().then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isNotEmpty){
        querySnapshot.docs.map( (event) {

        }
        );
      }
    });
  }
/*

  _getMarkerData() async {
    FirebaseFirestore.instance.collection("PlaniantEvent").get().then(
            (planiantEvents) => {
          if(planiantEvents.docs.isNotEmpty){
            for()
          }
        }
    );
  }

  Future<DocumentReference> _addPlaniantEvent() async {
    var position = await location.getLocation();
    GeoFirePoint point =
    geo.point(latitude: position.latitude, longitude: position.longitude);

    return firestore.collection('PlaniantEventFromMap').add({
      'position': point.data,
    });
  }
*/

}
