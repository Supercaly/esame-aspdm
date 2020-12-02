import 'package:aspdm_project/locator.dart';
import 'package:flutter/material.dart';
import 'package:aspdm_project/pages/main_page.dart';
import 'package:aspdm_project/routes.dart';
import 'package:aspdm_project/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ASPDM Project App",
      theme: lightTheme,
      navigatorKey: locator<NavigationService>().navigationKey,
      initialRoute: Routes.main,
      routes: {
        Routes.main: (_) => MainPage(),
      },
    );
  }
}
