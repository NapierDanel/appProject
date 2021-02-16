class Event {

  final String eventName;
  final String eventDescription;
  final String eventBeginDate;
  final String eventEndDate;
  final String eventImg;
  final String eventLocation;


  Event({this.eventName, this.eventDescription, this.eventBeginDate,
      this.eventEndDate, this.eventImg, this.eventLocation});

  factory Event.fromMap(Map data){
    return Event(
      eventName: data['name'] ?? 'No Name',
      eventDescription : data['description'] ?? 'No Idea',
      eventBeginDate : data['beginDate'] ?? 'No Plan',
      eventEndDate: data['endDate'] ?? 'No Plan',
      eventImg: data['img'] ?? '',
      eventLocation: data['location'],
    );
  }

}