import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/pages/archive_page.dart';
import 'package:aspdm_project/pages/login_page.dart';
import 'package:aspdm_project/pages/new_task_page.dart';
import 'package:aspdm_project/pages/task_info_page.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:aspdm_project/states/auth_state.dart';
import 'package:aspdm_project/states/task_state.dart';
import 'package:flutter/material.dart';
import 'package:aspdm_project/pages/main_page.dart';
import 'package:aspdm_project/routes.dart';
import 'package:aspdm_project/theme.dart';
import 'package:provider/provider.dart';

import 'model/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthState>(create: (context) => AuthState()),
        Provider<TaskState>(create: (_) => TaskState()),
      ],
      child: MaterialApp(
        title: "ASPDM Project App",
        theme: lightTheme,
        navigatorKey: locator<NavigationService>().navigationKey,
        routes: {
          Routes.newTask: (_) => NewTaskPage(),
          Routes.login: (_) => LoginPage(),
          Routes.archive: (_) => ArchivePage(),
          Routes.task: (_) => TaskInfoPage(),
        },
        home: Root(),
      ),
    );
  }
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<AuthState, User>(
      selector: (_, state) => state.currentUser,
      builder: (_, value, __) {
        if (value != null)
          return MainPage();
        else
          return LoginPage();
      },
    );
  }
}

