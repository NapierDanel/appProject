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
    return MaterialApp(
      title: 'Lugares',
      home: MapSample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState(){
    initPlaniantEvents();
    _currentLocation();
    super.initState();
  }

  initPlaniantEvents(){
    _database.collection('PlaniantEvents').get().then((docs) {
      if(docs.docs.isNotEmpty){
        for(int i= 0; i < docs.docs.length; i++) {
          initMarker(docs.docs[i], docs.docs[i].id);
        }
      }
    });
  }
  void initMarker(planiantEvent, planiantEventId) {
    print("planiantEventId: " + planiantEventId);
    var markerIdVal = planiantEventId;
    final MarkerId markerId = MarkerId(markerIdVal);
    print("TO STRING" + planiantEvent.get('planiantEventLatitude').toString());
    final planiantEventLatitudeString =  planiantEvent.get('planiantEventLatitude').toString();
    final planiantEventLongitudeString = planiantEvent.get('planiantEventLongitude').toString();

    print(planiantEventLongitudeString + planiantEventLatitudeString);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(num.parse(planiantEventLatitudeString)?.toDouble(), num.parse(planiantEventLongitudeString)?.toDouble()),
      infoWindow: InfoWindow(title: planiantEvent.get('planiantEventName'), snippet: planiantEvent.get('planiantEventDescription')),
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        trafficEnabled: false,
        buildingsEnabled: false,

        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }



  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 16.0,
      ),
    ));
  }

}














/*
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
          for(int i = 0; i< querySnapshot.docs.length ; i++){
            initMarker(querySnapshot.docs[i].data(), querySnapshot.docs[i].id);
          }
        }
        );
      }
    });
  }
  void initMarker(planiantEvent, eventId) {
    var markerIdVal = eventId;
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(planiantEvent['Latitud'], planiantEvent['Longitud']),
      infoWindow: InfoWindow(title: lugar['Lugar'], snippet: lugar['tipo']),

    );
  }


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


