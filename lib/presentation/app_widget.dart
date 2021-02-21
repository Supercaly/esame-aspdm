import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/application/bloc/auth_bloc.dart';
import 'package:tasky/domain/repositories/auth_repository.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/presentation/generated/gen_colors.g.dart';
import 'package:tasky/presentation/routes.dart';
import 'package:tasky/presentation/theme.dart';
import 'package:tasky/presentation/widgets/service_manager.dart';
import 'package:tasky/presentation/widgets/stream_listener.dart';
import 'package:tasky/services/connectivity_service.dart';
import 'package:tasky/services/link_service.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:tasky/services/notification_service.dart';
import 'package:flutter/material.dart';
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
      child: BlocProvider<AuthBloc>(
        create: (context) =>
            AuthBloc(repository: locator<AuthRepository>())..checkAuth(),
        child: ServiceManager(
          notificationService: locator<NotificationService>(),
          linkService: locator<LinkService>(),
          child: StreamListener<bool>(
            // TODO(#120): Move listener for connection state inside MainPage
            // Calling ScaffoldMessenger from here throws an error since there's not a Scaffold yet.
            stream: locator<ConnectivityService>().onConnectionStateChange,
            listener: (context, snapshot) {
              if (snapshot.hasData && !snapshot.data)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('device_offline_msg').tr(),
                  ),
                );
            },
            child: MaterialApp(
              title: "Tasky App",
              theme: lightTheme,
              darkTheme: darkTheme,
              navigatorKey: locator<NavigationService>().navigationKey,
              onGenerateRoute: Routes.onGenerateRoute,
              initialRoute: Routes.splash,
            ),
          ),
        ),
      ),
    );
  }
}
