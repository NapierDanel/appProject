import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_app_dev/bottomNavigation/_date_picker.dart';
import 'package:flutter_application_mobile_app_dev/bottomNavigation/_event_map.dart';
import 'package:flutter_application_mobile_app_dev/login/_login_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../data/_db.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';

/// Placeholder SVG
const String placeholderSVG = 'assets/images/ic_add_photo_alternate_24px.xml';

// ignore: must_be_immutable
class CreatePlaniantEventForm extends StatefulWidget {
  LatLng eventPosition;

  @override
  _CreatePlaniantEventFormState createState() =>
      _CreatePlaniantEventFormState(eventPosition);

  CreatePlaniantEventForm(this.eventPosition);
}

class _CreatePlaniantEventFormState extends State<CreatePlaniantEventForm> {
  final _formKey = GlobalKey<FormState>();
  String _documentId;
  LatLng eventPosition;

  _CreatePlaniantEventFormState(LatLng latLng) {
    this.eventPosition = latLng;
  }

  /// Controller to save the User Input
  final formControllerPlaniantEventName = TextEditingController();
  final formControllerPlaniantEventDescription = TextEditingController();
  final formControllerPlaniantEventBeginDate = TextEditingController();
  final formControllerPlaniantEventEndDate = TextEditingController();
  final formControllerPlaniantEventImg = TextEditingController();
  final formControllerPlaniantEventLocation = TextEditingController();
  final formControllerPlaniantEventLongitude = TextEditingController();
  final formControllerPlaniantEventLatitude = TextEditingController();

  @override
  void dispose() {
    formControllerPlaniantEventName.dispose();
    formControllerPlaniantEventDescription.dispose();
    formControllerPlaniantEventBeginDate.dispose();
    formControllerPlaniantEventEndDate.dispose();
    formControllerPlaniantEventImg.dispose();
    formControllerPlaniantEventLocation.dispose();
    formControllerPlaniantEventLongitude.dispose();
    formControllerPlaniantEventLatitude.dispose();
    super.dispose();
  }

  DatabaseService _dbService = DatabaseService();

  /// DateProvider
  DateProvider dateProvider = DateProvider();

  /// Event Image
  // ignore: non_constant_identifier_names
  File _planiant_event_image;
  final picker = ImagePicker();
  String _uploadedFileURL;

  IconData _eventImage = Icons.add_a_photo;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _planiant_event_image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Check if the User is logged in, if not -> push LoginPage
    // Get the firebase user
    User firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
      });
    }

    /// TODO Validate InputFields
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              /// Select Image
              GestureDetector(
                onTap: getImage,
                child: Center(
                  child: _planiant_event_image == null
                      ? CircleAvatar(
                          radius: 70.0,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 55,
                            color: Colors.white,
                          ),
                        )
                      : ClipRRect(
                          child: Image(
                            image: FileImage(_planiant_event_image),
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 10),

              /// Event Name
              TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a Event name';
                    }
                    return null;
                  },
                  controller: formControllerPlaniantEventName,
                  decoration: InputDecoration(
                    icon: Icon(Icons.event),
                    labelText: 'Event Name',
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  )),
              SizedBox(height: 20),

              /// Event Description
              TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a Event description';
                    }
                    return null;
                  },
                  controller: formControllerPlaniantEventDescription,
                  decoration: InputDecoration(
                    icon: Icon(Icons.drive_file_rename_outline),
                    labelText: 'Event Description',
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  )),
              SizedBox(height: 20),

              /// Begin date
              DatePicker("Select Begin Date", "begin"),
              SizedBox(height: 20),

              /// End date
              DatePicker("Select End Date", "end"),
              SizedBox(height: 20),

              /// Location
              TextFormField(
                  controller: formControllerPlaniantEventLocation,
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_on),
                    labelText: 'Location name',
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  )),
              SizedBox(height: 20),

              /*
              /// Lineup
              Center(
                  child: IconButton(
                tooltip: 'Add Lineup',
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LineUpWidget(),
                      ));
                },
              )),*/

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /// Reset Button
                  RaisedButton(
                    color: Colors.grey,
                    textColor: Colors.white,
                    onPressed: () {
                      /// reset all States
                      _formKey.currentState.reset();
                    },
                    child: Text('Reset'),
                  ),
                  SizedBox(width: 25),

                  /// Create Event Button
                  RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _sendPlaniantEventToServer(
                            _planiant_event_image, eventPosition);
                        print(formControllerPlaniantEventLatitude.text);
                        print("Valid input... Save to Firebase");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventMap(),
                          ),
                        );
                      } else {
                        print("Invalid Input...");
                      }
                      //Navigator.pop(context);
                    },
                    child: Text('Create'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _sendPlaniantEventToServer(File planiant_event_image, LatLng eventPosition) {
    if (_planiant_event_image == null) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("No Event Image was selected")));
      return null;
    }

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        CollectionReference reference =
            FirebaseFirestore.instance.collection('PlaniantEvents');

        List<Placemark> addresses = await placemarkFromCoordinates(
            eventPosition.latitude, eventPosition.longitude);
        String address;

        if (addresses[0] != null) {
          print('Address: ' +
              "Country: " +
              addresses[0].country +
              "\n" +
              "ISO Country Code:" +
              addresses[0].isoCountryCode +
              "\n" +
              "Name: " +
              addresses[0].name +
              "\n" +
              "AminArea: " +
              addresses[0].administrativeArea +
              "\n" +
              "Locality: " +
              addresses[0].locality +
              "\n" +
              "Street: " +
              addresses[0].street +
              "\n" +
              FirebaseAuth.instance.currentUser.displayName);
          address = addresses[0].street + " " + addresses[0].administrativeArea;
        } else {
          address = 'Nowhere';
          print('Address' + addresses.first.country);
        }

        /// PlaniantEvent Document upload
        await reference.add({
          "planiantEventName": formControllerPlaniantEventName.text,
          "planiantEventDescription":
              formControllerPlaniantEventDescription.text,
          "planiantEventBeginDate": DateProvider.beginDate,
          "planiantEventEndDate": DateProvider.endDate,
          "planiantEventImg": formControllerPlaniantEventImg.text,
          "planiantEventLocation": address,
          "planiantEventLongitude": eventPosition.longitude.toString(),
          "planiantEventLatitude": eventPosition.latitude.toString(),
          "planiantEventOrganizerId": FirebaseAuth.instance.currentUser.uid,
          "planiantEventOrganizerName":
              FirebaseAuth.instance.currentUser.displayName
        }).then((value) =>
            {_documentId = value.id, print('DOCUMENT ID: ' + _documentId)});

        print(_documentId);

        /// PlaniantEvent Image upload
        firebase_storage.UploadTask uploadTask;

        firebase_storage.Reference storage = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child("PlaniantEventImages")
            .child("${_documentId}_titleImg");

        print("Upload Image...");
        uploadTask = storage.putData(await _planiant_event_image.readAsBytes());
      });
    } else {
      // validation error
      setState(() {});
    }
  }
}

/// Date Provider
class DateProvider {
  static String beginDate;
  static String endDate;
}

/// State management
///
/// UI = f(State)
/// Local State = one widget
///
/// setState: rebuild all the widgets in the function
///
///

class _EventDatePickerState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EventDatePicker();
}

class _EventDatePicker extends State<_EventDatePickerState> {
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Date'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("${selectedDate.toLocal()}".split(' ')[0]),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select date'),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaniantEventImagePicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {}
}
