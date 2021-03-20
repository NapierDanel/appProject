import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_app_dev/_date_picker.dart';
import 'package:flutter_application_mobile_app_dev/bottomNavigation/_lineup.dart';
import 'package:image_picker/image_picker.dart';
import '../_db.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_svg/flutter_svg.dart';

/// Placeholder SVG 
const String placeholderSVG = 'assets/images/ic_add_photo_alternate_24px.xml';


class CreatePlaniantEventForm extends StatefulWidget {


  @override
  _CreatePlaniantEventFormState createState() =>
      _CreatePlaniantEventFormState();

  CreatePlaniantEventForm();

}

class _CreatePlaniantEventFormState extends State<CreatePlaniantEventForm> {
  final _formKey = GlobalKey<FormState>();
  String _documentId;
  
 
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
    /// TODO Validate InputFields
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              /// TODO show chosen Image
              /// Select Image
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: new Image.asset('images/ic_add_photo_alternate_24px.xml'),
                ),
              ),
              FloatingActionButton(
                onPressed: getImage,
                tooltip: 'Pick Image',
                child: Icon(Icons.add_a_photo),
              ),
              SizedBox(height: 10),

              /// Event Name
              TextFormField(
                  controller: formControllerPlaniantEventName,
                  cursorColor: Theme.of(context).cursorColor,
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
                  controller: formControllerPlaniantEventDescription,
                  cursorColor: Theme.of(context).cursorColor,
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
                  cursorColor: Theme.of(context).cursorColor,
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_on),
                    labelText: 'Location',
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  )),
              SizedBox(height: 20),

              /// Location LAT LON
              TextFormField(

                  /// TODO LATLON Handling
                  controller: formControllerPlaniantEventLatitude,
                  cursorColor: Theme.of(context).cursorColor,
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_on_outlined),
                    labelText: 'Location LAT LON',
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  )),
              SizedBox(height: 20),

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
              )),

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

                  /// Preview
                  RaisedButton(
                    color: Colors.amber[800],
                    textColor: Colors.white,
                    onPressed: () {
                      /// TODO add Preview Widget
                    },
                    child: Text('Preview'),
                  ),
                  SizedBox(width: 25),

                  /// Create Event Button
                  RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _sendPlaniantEventToServer(_planiant_event_image);
                        print(formControllerPlaniantEventLatitude.text);
                        print("Valid input... Save to Firebase");
                      } else {
                        print("Invalid Input...");
                      }
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

  _sendPlaniantEventToServer(File planiant_event_image) {
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

        /// PlaniantEvent Document upload
        await reference.add({
          "planiantEventName": formControllerPlaniantEventName.text,
          "planiantEventDescription":
              formControllerPlaniantEventDescription.text,
          "planiantEventBeginDate": DateProvider.beginDate,
          "planiantEventEndDate": DateProvider.endDate,
          "planiantEventImg": formControllerPlaniantEventImg.text,
          "planiantEventLocation": formControllerPlaniantEventLocation.text,
          "planiantEventLongitude": formControllerPlaniantEventLongitude.text,
          "planiantEventLatitude": formControllerPlaniantEventLatitude.text,
        }).then((value) => _documentId = value.id);

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
