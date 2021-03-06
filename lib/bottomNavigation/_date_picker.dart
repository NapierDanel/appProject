import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_app_dev/bottomNavigation/_create_planiant_event.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  @override
  _DatePickerState createState() => _DatePickerState();

  final String text;
  final String dateType;

  DatePicker(this.text, this.dateType);
}

class _DatePickerState extends State<DatePicker> {
  DateTime selectedDate = DateTime.now();
  DateProvider eventPusher = DateProvider();
  final DateFormat formatter = DateFormat('dd.MM.yyyy');
  String selectDateString = 'select date';

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDate) {
      print('Selected Date $selectedDate');
      setState(() {
        /// Check the context
        switch (widget.dateType) {
          case 'begin':
            print(formatter.format(picked).toString());
            DateProvider.beginDate = formatter.format(picked);
            selectDateString = formatter.format(picked).toString();
            break;
          case 'end':
            DateProvider.endDate = formatter.format(picked);
            selectDateString = formatter.format(picked).toString();
            break;
          default:
            print('Wrong date string');
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _selectDate(context),
        child: TextFormField(
            enabled: false,
            decoration: InputDecoration(
              icon: Icon(Icons.event),
              labelText: selectDateString,
              labelStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
              border: OutlineInputBorder(),
            )));
  }
}
