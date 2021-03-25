import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_app_dev/data/_firebase_planiant_event.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class PlaniantEventDetailScreen extends StatelessWidget {
  PlaniantEvent planiantEvent;
  Image planiantEventImage;

  PlaniantEventDetailScreen({Key key, @required this.planiantEvent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      /// Image Section
      FutureBuilder<String>(
          future: _getStoragePlaniantEventImageURL(planiantEvent.id.toString()),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                child: LinearProgressIndicator(),
                width: 60,
                height: 60,
              );
            } else if (snapshot.hasData) {
              this.planiantEventImage = Image.network(
                snapshot.data,
                fit: BoxFit.cover,
                height: 300,
                semanticLabel: 'Event Image',
              );
              return GestureDetector(
                child: Hero(
                  tag: 'imageHero',
                  child: planiantEventImage,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return DetailImageScreen(planiantEventImage);
                  }));
                },
              );
            } else if (snapshot.hasError) {
              return Text('Failure Loading Even Image');
            } else {
              return SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              );
            }
          }),

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

            /// When the user  Icon Button pressed
            IconButton(
              onPressed: () => {
                addPlaniantEventToCalendar(planiantEvent),
                SnackBar(content: Text('Event added to calendar')),
              },
              icon: new Icon(Icons.event),
              color: Colors.blue,
              splashColor: Colors.orange,
              highlightColor: Colors.blue,
            ),
          ],
        ),
      ),

      /// Description
      Container(
        padding: const EdgeInsets.all(32),
        child: Text(planiantEvent.planiantEventDescription,
            style: TextStyle(
              fontSize: 12,
            )),
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

  Container _choiceButtonColumn(Color color, IconData icon, String label) {
    return Container(
      color: color,
      margin: const EdgeInsets.all(10.0),
      child: Column(
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
      ),
    );
  }

  addPlaniantEventToCalendar(PlaniantEvent planiantEvent) {
    Event calendarEvent = Event(
      title: planiantEvent.planiantEventName,
      description: planiantEvent.planiantEventDescription,
      location: planiantEvent.planiantEventLocation,
      startDate:
          DateFormat("dd.MM.yyyy").parse(planiantEvent.planiantEventBeginDate),
      endDate:
          DateFormat("dd.MM.yyyy").parse(planiantEvent.planiantEventEndDate),
      alarmInterval: Duration(minutes: 30),
    );

    Add2Calendar.addEvent2Cal(calendarEvent, androidNoUI: false);
  }

  Future<String> _getStoragePlaniantEventImageURL(String id) async {
    print('in methond');

    String planiantEventImagePath = 'PlaniantEventImages/' + id + '_titleImg';
    print('planiantEventImagePath:' + planiantEventImagePath);

    final ref = FirebaseStorage.instance.ref().child(planiantEventImagePath);

    var url = await ref.getDownloadURL();
    print('URL:' + url);
    return url;
  }
}

class DetailImageScreen extends StatelessWidget {
  Image image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
            child: Hero(
          tag: 'imageHero',
          child: Container(
              child: PhotoView(
            imageProvider: image.image,
          )),
        )),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  DetailImageScreen(Image image) {
    this.image = image;
  }
}
