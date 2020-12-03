import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/pages/archive_page.dart';
import 'package:aspdm_project/pages/login_page.dart';
import 'package:aspdm_project/pages/new_task_page.dart';
import 'package:aspdm_project/services/navigation_service.dart';
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
        Routes.newTask: (_) => NewTaskPage(),
        Routes.login: (_) => LoginPage(),
        Routes.archive: (_) => ArchivePage(),
      },
    );
  }
}
