import 'package:flutter_application_mobile_app_dev/business_logic/view_model/event_map_viewmodel.dart';
import 'package:flutter_application_mobile_app_dev/business_logic/view_model/home_viewmodel.dart';
import 'package:flutter_application_mobile_app_dev/business_logic/view_model/my_profile_viewmodel.dart';
import 'package:flutter_application_mobile_app_dev/services/firebase_api/firebase_api.dart';
import 'package:flutter_application_mobile_app_dev/services/firebase_api/firebase_api_impl.dart';
///The serviceLocator is a singleton object that knows all the services the app uses
import 'package:get_it/get_it.dart';

/// get_it keeps track of all registered objects
/// The service locator is a global singleton that can be accessed from anywhere within the app
GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {

  /// Register lazy singleton services
  serviceLocator.registerLazySingleton<FirebaseApi>(() => FirebaseApiImpl());

  /// register ViewModels
  serviceLocator.registerFactory<HomeViewModel>(() => HomeViewModel());
  serviceLocator.registerFactory<MyProfileViewModel>(() => MyProfileViewModel());
  serviceLocator.registerFactory<EventMapViewModel>(() => EventMapViewModel());
}