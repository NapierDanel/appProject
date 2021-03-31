import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_app_dev/data/_firebase_planiant_event.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter_application_mobile_app_dev/data/_user.dart';
import 'package:flutter_application_mobile_app_dev/login/_login_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class PlaniantEventDetailScreen extends StatelessWidget {
  PlaniantEvent planiantEvent;
  Image planiantEventImage;

  /// Show this image if there is no EventImage
  final String noImageSvgPath = 'assets/images/no-photos.png';

  PlaniantEventDetailScreen({Key key, @required this.planiantEvent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        /// Image Section
        FutureBuilder<String>(

            /// load the event image from firebase
            future:
                _getStoragePlaniantEventImageURL(planiantEvent.id.toString()),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                this.planiantEventImage = Image.network(
                  snapshot.data,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      /// Show the progress of loading
                      heightFactor: 300,
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
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
              } else if (!snapshot.hasData) {
                return SizedBox(
                    child: Image.asset(
                  noImageSvgPath,
                  height: 200,
                  width: 300,
                  color: Colors.blue,
                  scale: 3,
                ));
              } else if (snapshot.hasError) {
                return Text('Failure Loading Even Image');
              } else {
                return SizedBox(
                    child: Image.asset(
                  noImageSvgPath,
                  height: 200,
                  width: 300,
                ));
              }
            }),

        /// Title Section
        Container(
          padding: const EdgeInsets.all(16),
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
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Text(
                      planiantEvent.planiantEventLocation,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
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
                tooltip: 'Add to your Calendar',
                iconSize: 45,
                color: Colors.blue,
                splashColor: Colors.orange,
              ),
            ],
          ),
        ),

        /// Date
        Card(
          child: ListTile(
            leading: Icon(Icons.access_time_rounded),
            title: Text(planiantEvent.planiantEventBeginDate +
                "  -  " +
                planiantEvent.planiantEventEndDate),
          ),
        ),

        /// organizer
        Card(
          child: ListTile(
            leading: Icon(Icons.description),
            title: Text(planiantEvent.planiantEventDescription),
          ),
        ),

        /// organizer
        Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(
                planiantEvent.planiantEventOrganizerName ?? 'No Organizer'),
          ),
        ),

        /// Choice Section
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _choiceButtonColumn(
                  Colors.lightGreenAccent, Icons.add, 'I AM IN', context),
              _choiceButtonColumn(Colors.redAccent, Icons.remove, 'I AM OUT', context),
            ],
          ),
        ),
      ]),
    );
  }

  GestureDetector _choiceButtonColumn(
      Color color, IconData icon, String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FirebaseAuth.instance.currentUser != null) {
          if (label == 'I AM IN') {
            PlaniantUser.getPlaniantUserInstance()
                .addAcceptPlaniantEvent(planiantEvent.id);
            final snackBar = SnackBar(content: Text('Added to Favorites'));

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          if (label == 'I AM OUT') {
            print(FirebaseAuth.instance.currentUser);
            PlaniantUser.getPlaniantUserInstance()
                .removeAcceptPlaniantEvent(planiantEvent.id);

            final snackBar = SnackBar(content: Text('Removed from Favorites'));

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          return null;
        }
      },
      child: Container(
        color: color,
        height: 100,
        width: 100,
        margin: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            Container(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
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
    String planiantEventImagePath = 'PlaniantEventImages/' + id + '_titleImg';

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
      backgroundColor: Colors.black,
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
