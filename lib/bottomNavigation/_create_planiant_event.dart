import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../_db.dart';

class CreatePlaniantEventForm extends StatefulWidget {
  @override
  _CreatePlaniantEventFormState createState() =>
      _CreatePlaniantEventFormState();
}

class _CreatePlaniantEventFormState extends State<CreatePlaniantEventForm> {
  final _formKey = GlobalKey<FormState>();

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

              /// Select Image

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
              TextFormField(
                  controller: formControllerPlaniantEventBeginDate,
                  cursorColor: Theme.of(context).cursorColor,
                  decoration: InputDecoration(
                    icon: Icon(Icons.access_time),
                    labelText: 'Begin date',
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  )),
              SizedBox(height: 20),

              /// End date
              TextFormField(
                  controller: formControllerPlaniantEventEndDate,
                  cursorColor: Theme.of(context).cursorColor,
                  decoration: InputDecoration(
                    icon: Icon(Icons.access_time),
                    labelText: 'End date',
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  )),
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
                        _sendPlaniantEventToServer();
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

  _sendPlaniantEventToServer() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        CollectionReference reference =
            FirebaseFirestore.instance.collection('PlaniantEvent');
        await reference.add({
          "planiantEventName": formControllerPlaniantEventName.text,
          "planiantEventDescription":
              formControllerPlaniantEventDescription.text,
          "planiantEventBeginDate": formControllerPlaniantEventBeginDate.text,
          "planiantEventEndDate": formControllerPlaniantEventEndDate.text,
          "planiantEventImg": formControllerPlaniantEventImg.text,
          "planiantEventLocation": formControllerPlaniantEventLocation.text,
          "planiantEventLongitude": formControllerPlaniantEventLongitude.text,
          "planiantEventLatitude": formControllerPlaniantEventLatitude.text,
        });
      });
    } else {
      // validation error
      setState(() {});
    }
  }
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
