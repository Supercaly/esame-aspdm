import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/presentation/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart' as intl;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await intl.initializeDateFormatting("en");

  // Initialize Firebase
  await Firebase.initializeApp();

  // Init locator services
  await setupLocator();

  runApp(AppWidget());
}
