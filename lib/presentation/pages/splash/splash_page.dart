import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/application/bloc/auth_bloc.dart';
import 'package:tasky/services/log_service.dart';
import 'package:tasky/services/navigation_service.dart';
import '../../../locator.dart';
import '../../routes.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        locator<LogService>().info("Auth state - $state");
        state.map(
          initial: (_) {},
          authenticated: (_) =>
              locator<NavigationService>().replaceWith(Routes.main),
          unauthenticated: (_) =>
              locator<NavigationService>().replaceWith(Routes.login),
        );
      },
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
