import 'dart:async';
import '_user_location.dart';
import 'package:location/location.dart';

class LocationService{

  /// Keep track of current Location
  UserLocation _currentLocation;

  Location location = Location();

  /// Continuously emit location updates
  StreamController<UserLocation> _locationController = StreamController<UserLocation>.broadcast();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService(){
    location.requestPermission().then((granted) {
      if(granted == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          if(locationData != null){
            _locationController.add(UserLocation(latitude: locationData.latitude, longitude: locationData.longitude));
          }
        });
      }
    });
  }

  Future<UserLocation> getLocation() async {
    try{
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    }catch(e){
      print('Could not get the location');
    }
    return _currentLocation;
  }


}