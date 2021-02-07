import 'package:aspdm_project/application/states/auth_state.dart';
import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/repositories/auth_repository.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/presentation/generated/gen_colors.g.dart';
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
import 'package:easy_localization/easy_localization.dart';
import 'package:aspdm_project/presentation/generated/codegen_loader.g.dart';

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
