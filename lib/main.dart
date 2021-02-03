import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/presentation/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Init locator services
  await setupLocator();

  runApp(AppWidget());
}
