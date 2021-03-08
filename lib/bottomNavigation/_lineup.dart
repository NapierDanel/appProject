import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LineUpWidget extends StatefulWidget {
  @override
  _LineUpWidgetState createState() => _LineUpWidgetState();
}

class _LineUpWidgetState extends State<LineUpWidget> {
  final List<String> names = <String>['Aby', 'Aish', 'Ayan', 'Ben', 'Bob', 'Charlie', 'Cook', 'Carline'];
  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];

  TextEditingController nameController = TextEditingController();

  void addItemToList(){
    setState(() {
      names.insert(0,nameController.text);
      msgCount.insert(0, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Bla');

  }
}