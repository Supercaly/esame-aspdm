import 'package:easy_localization/easy_localization.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/presentation/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Init locator services
  await setupLocator();

  runApp(AppWidget());
}
