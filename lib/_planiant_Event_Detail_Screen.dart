import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_app_dev/data/_firebase_planiant_event.dart';

class PlaniantEventDetailScreen extends StatelessWidget {
  PlaniantEvent planiantEvent;

  PlaniantEventDetailScreen({Key key, @required this.planiantEvent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [

      /// Image Section
      Image.asset(
        'assets/images/drawerHeaderImg.jpeg',
        width: 600,
        height: 240,
        fit: BoxFit.cover,
      ),

      /// Title Section
      Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      planiantEvent.planiantEventName,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    planiantEvent.planiantEventLocation,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            /*3*/
            Icon(
              Icons.event,
              color: Colors.blue,

            ),
          ],
        ),
      ),

      /// Description
      Container(
        padding: const EdgeInsets.all(32),
        child: Text(
          planiantEvent.planiantEventDescription,
          style: TextStyle(
            fontSize: 12,
          )
        ),
      ),

      /// Choice Section
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _choiceButtonColumn(Colors.lightGreenAccent, Icons.add, 'I AM IN'),
            _choiceButtonColumn(Colors.redAccent, Icons.remove, 'I AM OUT'),
          ],
        ),
      ),
    ]);
  }

  Column _choiceButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
