import 'package:tasky/application/states/auth_state.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/repositories/auth_repository.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/presentation/generated/gen_colors.g.dart';
import 'package:tasky/presentation/pages/login_page.dart';
import 'package:tasky/presentation/pages/main_page.dart';
import 'package:tasky/presentation/routes.dart';
import 'package:tasky/presentation/theme.dart';
import 'package:tasky/presentation/widgets/service_manager.dart';
import 'package:tasky/presentation/widgets/stream_listener.dart';
import 'package:tasky/services/connectivity_service.dart';
import 'package:tasky/services/link_service.dart';
import 'package:tasky/services/log_service.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:tasky/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tasky/presentation/generated/codegen_loader.g.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('it'),
      ],
      path: "assets/translations",
      assetLoader: CodegenLoader(),
      fallbackLocale: Locale('en'),
      preloaderColor: EasyColors.primary,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthState>(
            create: (context) => AuthState(locator<AuthRepository>()),
          ),
        ],
        child: ServiceManager(
          notificationService: locator<NotificationService>(),
          linkService: locator<LinkService>(),
          child: MaterialApp(
            title: "Tasky App",
            theme: lightTheme,
            darkTheme: darkTheme,
            navigatorKey: locator<NavigationService>().navigationKey,
            initialRoute: Routes.main,
            onGenerateRoute: Routes.onGenerateRoute,
          ),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('device_offline_msg').tr(),
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
