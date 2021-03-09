import 'dart:async';
import 'dart:html';

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
  Location location = new Location();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  /// PlaniantEvents
  BehaviorSubject<double> radius = BehaviorSubject();
  Stream<dynamic> query;

  /// Subscription
  StreamSubscription subscription;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(47.72674, 10.31389),
            zoom: 15,
          ),
          onMapCreated: _onMapCreated,
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          mapType: MapType.satellite,
          onCameraMove: _updateMarkers,
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
              onPressed: () {
                _addPlaniantEvent();
              },
            ),
          ),
        )
      ],
    );
  }

  _onMapCreated(GoogleMapController controller) {
    _animateToUser();
    setState(() {});
  }

  void _updateMarkers(List<DocumentSnapshot> documentList){
    print(documentList);
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint pos = document.data['position']['geopoint'];
      double distance = document.data['distance'];
      var marker = Marker(
          position: LatLng(pos.latitude, pos.longitude),
          icon: BitmapDescriptor.defaultMarker,

      );


      mapController.add(marker);
    });
  }

  _animateToUser() async {
    var position = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 15)));
  }

  Future<DocumentReference> _addPlaniantEvent() async {
    var position = await location.getLocation();
    GeoFirePoint point =
        geo.point(latitude: position.latitude, longitude: position.longitude);

    return firestore.collection('PlaniantEventFromMap').add({
      'position': point.data,
    });
  }
}
