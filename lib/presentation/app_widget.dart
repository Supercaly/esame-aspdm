import 'package:aspdm_project/application/states/auth_state.dart';
import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/repositories/auth_repository.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/presentation/pages/login_page.dart';
import 'package:aspdm_project/presentation/pages/main_page.dart';
import 'package:aspdm_project/presentation/routes.dart';
import 'package:aspdm_project/presentation/theme.dart';
import 'package:aspdm_project/presentation/widgets/service_manager.dart';
import 'package:aspdm_project/presentation/widgets/stream_listener.dart';
import 'package:aspdm_project/services/connectivity_service.dart';
import 'package:aspdm_project/services/link_service.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:aspdm_project/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthState>(
          create: (context) => AuthState(locator<AuthRepository>()),
        ),
      ],
      child: ServiceManager(
        notificationService: locator<NotificationService>(),
        linkService: locator<LinkService>(),
        child: MaterialApp(
          title: "ASPDM Project App",
          theme: lightTheme,
          darkTheme: darkTheme,
          navigatorKey: locator<NavigationService>().navigationKey,
          initialRoute: Routes.main,
          onGenerateRoute: Routes.onGenerateRoute,
        ),
      ),
    );
  }
}

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamListener<bool>(
      listener: (_, status) {
        if (status.hasData && !status.data)
          // TODO(#78): Fix bug with "device is offline" snack-bar
          // After a hot-restart sometimes the devices looks offline so the snack-bar is displayed during build time resulting in this error message:
          // ```
          // The following assertion was thrown building RootWidget(dependencies: [_ScaffoldMessengerScope]):
          // setState() or markNeedsBuild() called during build.
          //
          // This ScaffoldMessenger widget cannot be marked as needing to build because the framework is already in the process of building widgets.  A widget can be marked as needing to be built during the build phase only if one of its ancestors is currently building. This exception is allowed because the framework builds parent widgets before children, which means a dirty descendant will always be built. Otherwise, the framework might not visit this widget during this build phase.
          // The widget on which setState() or markNeedsBuild() was called was: ScaffoldMessenger
          // dependencies: [MediaQuery]
          // state: ScaffoldMessengerState#1f92d(tickers: tracking 1 ticker)
          // The widget which was currently being built when the offending call was made was: RootWidget
          // dependencies: [_ScaffoldMessengerScope]
          // The relevant error-causing widget was:
          // RootWidget file:///home/lorenzo/Scrivania/FlutterProjects/aspdm_project/lib/presentation/routes.dart:43:33
          //     : To inspect this widget in Flutter DevTools, visit: http://127.0.0.1:9100/#/inspector?uri=http%3A%2F%2F127.0.0.1%3A32817%2Fl3Wk2VfhU48%3D%2F&inspectorRef=inspector-0
          // When the exception was thrown, this was the stack:
          // #0      Element.markNeedsBuild.<anonymous closure> (package:flutter/src/widgets/framework.dart:4138:11)
          // #1      Element.markNeedsBuild (package:flutter/src/widgets/framework.dart:4153:6)
          // #2      State.setState (package:flutter/src/widgets/framework.dart:1287:15)
          // #3      ScaffoldMessengerState.showSnackBar (package:flutter/src/material/scaffold.dart:351:5)
          // #4      RootWidget.build.<anonymous closure> (package:aspdm_project/presentation/app_widget.dart:44:41)
          // ...
          // ```
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("The device is offline!"),
            ),
          );
      },
      stream: locator<ConnectivityService>().onConnectionStateChange,
      child: Selector<AuthState, Maybe<User>>(
        selector: (_, state) => state.currentUser,
        builder: (_, value, __) {
          locator<LogService>().logBuild("Root $value");
          if (value.isJust())
            return MainPage();
          else
            return LoginPage();
        },
      ),
    );
  }
}
