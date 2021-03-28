import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_mobile_app_dev/bottomNavigation/_planiant_Event_Detail_Screen.dart';
import 'package:flutter_application_mobile_app_dev/data/_firebase_planiant_event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../data/_db.dart';
import '_create_planiant_event.dart';

class EventMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PlaniantEventMap(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PlaniantEventMap extends StatefulWidget {
  @override
  State<PlaniantEventMap> createState() => MapSampleState();
}

class MapSampleState extends State<PlaniantEventMap> {
  /// Firebase Database
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  /// Map Controller
  Completer<GoogleMapController> _controller = Completer();

  /// User Location
  LocationData currentLocation;
  var location = new Location();

  /// Map controller for Updates
  GoogleMapController controller;

  /// PlaniantEvent Markers
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor planiantEventIcon;
  Set<Marker> _markers = {};

  /// Create Event LatLng
  LatLng createEventLatLng;
  BitmapDescriptor addPlaniantEventMarker;

  /// Do this when init
  @override
  void initState() {
    getPlaniantEventIcon();
    initPlaniantEvents();
    _currentLocation();
    super.initState();
  }

  getPlaniantEventIcon() async {
    var planiantEventMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(3, 3)),
        'assets/images/planiant_Event_Marker.png');

    /// TODO add Event Icon
    var addPlaniantEventMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(3, 3)),
        'assets/images/create_Planiant_Event_Marker.png');

    setState(() {
      this.planiantEventIcon = planiantEventMarkerIcon;
      this.addPlaniantEventMarker = addPlaniantEventMarkerIcon;
    });
  }

  initPlaniantEvents() {
    _database.collection('PlaniantEvents').get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; i++) {
          print(docs.docs[i].id);
          initMarker(docs.docs[i], docs.docs[i].id);
        }
      }
    });
  }

  void initMarker(rawPlaniantEvent, planiantEventId) {
    var markerIdVal = planiantEventId;
    final MarkerId markerId = MarkerId(markerIdVal);

    final planiantEventNameString =
    rawPlaniantEvent.get('planiantEventName').toString();
    final planiantEventDescriptionString =
    rawPlaniantEvent.get('planiantEventDescription').toString();
    final planiantEventBeginDateString =
    rawPlaniantEvent.get('planiantEventBeginDate').toString();
    final planiantEventEndDateString =
    rawPlaniantEvent.get('planiantEventEndDate').toString();
    final planiantEventImgString =
    rawPlaniantEvent.get('planiantEventImg').toString();
    final planiantEventLocationString =
    rawPlaniantEvent.get('planiantEventLocation').toString();
    final planiantEventLatitudeString =
    rawPlaniantEvent.get('planiantEventLatitude').toString();
    final planiantEventLongitudeString =
    rawPlaniantEvent.get('planiantEventLongitude').toString();

    PlaniantEvent planiantEvent = new PlaniantEvent(
        planiantEventName: planiantEventNameString,
        planiantEventDescription: planiantEventDescriptionString,
        planiantEventBeginDate: planiantEventBeginDateString,
        planiantEventEndDate: planiantEventEndDateString,
        planiantEventLocation: planiantEventLocationString,
        planiantEventLongitude: planiantEventLongitudeString,
        planiantEventLatitude: planiantEventLatitudeString,
        id: planiantEventId
    );

    /// creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      icon: planiantEventIcon,
      position: LatLng(num.parse(planiantEventLatitudeString)?.toDouble(),
          num.parse(planiantEventLongitudeString)?.toDouble()),
      infoWindow: InfoWindow(
        title: rawPlaniantEvent.get('planiantEventName'),
        snippet: rawPlaniantEvent.get('planiantEventDescription'),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PlaniantEventDetailScreen(planiantEvent: planiantEvent)));
        },
      ),
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  PlaniantEvent createPlaniantEventFromFirebase(
      QueryDocumentSnapshot rawPlaniantEvent, String planiantEventId) {
    /// Create PlaniantEventObject and add them to map for later use
    return new PlaniantEvent(
      planiantEventDescription:
      rawPlaniantEvent.get('planiantEventDescription').toString(),
      planiantEventBeginDate:
      rawPlaniantEvent.get('planiantEventBeginDate').toString(),
      planiantEventEndDate:
      rawPlaniantEvent.get('planiantEventEndDate').toString(),
      planiantEventImg: rawPlaniantEvent.get('planiantEventImg').toString(),
      planiantEventLocation:
      rawPlaniantEvent.get('planiantEventLocation').toString(),
      planiantEventLongitude:
      rawPlaniantEvent.get('planiantEventLongitude').toString(),
      planiantEventLatitude:
      rawPlaniantEvent.get('planiantEventLatitude').toString(),
      id: rawPlaniantEvent.get('id').toString(),
    );
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return new Stack(children: [
      GoogleMap(
        onTap: (latLng) {
          MarkerId markerId = MarkerId('123456789');
          final Marker marker = Marker(
            markerId: markerId,
            icon: addPlaniantEventMarker,
            position: latLng,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreatePlaniantEventForm(latLng)));
            },

          );

          setState(() {
            // adding a new marker to map
            markers[markerId] = marker;
          });
        },
        zoomControlsEnabled: false,
        mapType: MapType.hybrid,
        trafficEnabled: false,
        buildingsEnabled: false,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        markers: Set<Marker>.of(markers.values),
        indoorViewEnabled: false,
      ),
    ]);
  }

  void _currentLocation() async {
    controller = await _controller.future;
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17,
      ),
    ));
  }

  _animateToUser() async {
    var pos = await location.getLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 14.4746,
      ),
    ));
  }

  void _uptdateMarksers(List<DocumentSnapshot> documentList){
    print(documentList);

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