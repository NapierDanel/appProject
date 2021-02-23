import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CreatePlaniantEvent extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  String id;
  String planiantEventName;
  String planiantEventDescription;
  String planiantEventBeginDate;
  String planiantEventEndDate;
  String planiantEventImg;
  String planiantEventLocation;
  String planiantEventLongitude;
  String planiantEventLatitude;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              /// Event Name
              TextFormField(
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
