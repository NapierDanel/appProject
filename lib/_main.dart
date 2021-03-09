import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'my_app.dart';
import 'drawer/_settings.dart';

/**
 * --ToDo--
 * [] Drawer
 * [] Button Menu
 * [] QR Code Scanner
 * [] Line up Generator
 *
 * --Animation--
 * Hero
 * Flair
 * --List--
 * Listview
 *
 * -- StateManagement--
 * get_it keep it simple
 * create a global singleton
 * Provider Context
 * --> Firebase
 *
 *
 *
 */

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
