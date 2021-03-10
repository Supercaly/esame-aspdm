import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/application/bloc/login_bloc.dart';
import 'package:tasky/presentation/pages/login/widgets/login_form.dart';
import 'package:tasky/services/log_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tasky/core/either.dart';
import '../../../../mocks/mock_login_bloc.dart';
import '../../../../mocks/mock_log_service.dart';
import '../../../../widget_tester_extension.dart';

void main() async {
  EasyLocalization.logger.enableBuildModes = [];
  await EasyLocalization.ensureInitialized();

  group("LoginForm test", () {
    LogService logService;
    LoginBloc loginBloc;

    setUpAll(() {
      logService = MockLogService();
      loginBloc = MockLoginBloc();

      when(logService).calls(#debug).thenReturn();
      GetIt.I.registerSingleton(logService);
    });

    tearDown(() {
      reset(loginBloc);
    });

    tearDownAll(() {
      loginBloc.close();
      logService = null;
      loginBloc = null;
    });

    testWidgets("create widget with success", (tester) async {
      await tester.pumpLocalizedWidget(LoginForm());

      expect(find.text("Email"), findsOneWidget);
      expect(find.text("Password"), findsOneWidget);
      expect(find.text("Log In"), findsOneWidget);
    });

    testWidgets("login with correct data", (tester) async {
      when(loginBloc)
          .calls(#login)
          .thenAnswer((_) async => Either.right(Unit()));
      await tester.pumpLocalizedWidget(
        BlocProvider<LoginBloc>.value(
          value: loginBloc,
          child: LoginForm(),
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, "user@mail.com");
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).last, "mock_password");
      await tester.pumpAndSettle();
      await tester.tap(find.text("Log In"));
      await tester.pumpAndSettle();
      verify(loginBloc).called(#login).once();
    });

    testWidgets("login with invalid data", (tester) async {
      when(loginBloc).calls(#login).withArgs(
          positional: [any, any]).thenAnswer((_) async => Either.right(Unit()));
      await tester.pumpLocalizedWidget(
        BlocProvider<LoginBloc>.value(
          value: loginBloc,
          child: LoginForm(),
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, "user.com");
      await tester.pumpAndSettle();
      await tester.tap(find.text("Log In"));
      await tester.pumpAndSettle();

      expect(find.text("Email is not valid!"), findsOneWidget);
      expect(find.text("Password can't be empty!"), findsOneWidget);
      verify(loginBloc).called(#login).never();
    });
  });
}
