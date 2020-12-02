import 'package:flutter/material.dart';
import 'package:aspdm_project/pages/main_page.dart';
import 'package:aspdm_project/routes.dart';
import 'package:aspdm_project/theme.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ASPDM Project App",
      theme: lightTheme,
      initialRoute: Routes.main,
      routes: {
        Routes.main: (_) => MainPage(),
      },
    );
  }
}
