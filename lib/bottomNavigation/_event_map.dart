import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../_create_event_button.dart';
import 'package:location/location.dart';

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
  @override
  Widget build(BuildContext context) {
    print('BIN DRIN');
    return Stack(
      children: [
        GoogleMap(
            initialCameraPosition: CameraPosition(
          target: LatLng(24.142, -110.321),
          zoom: 15,
        ))
      ],
    );
  }
}
