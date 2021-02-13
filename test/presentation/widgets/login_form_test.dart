import 'package:tasky/domain/failures/server_failure.dart';
import 'package:tasky/presentation/widgets/login_form.dart';
import 'package:tasky/services/log_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasky/application/states/auth_state.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/either.dart';
import '../../mocks/mock_auth_state.dart';
import '../../mocks/mock_log_service.dart';
import '../../widget_tester_extension.dart';

void main() {
  group("LoginForm test", () {
    LogService logService;
    AuthState authState;

    setUpAll(() {
      logService = MockLogService();
      authState = MockAuthState();

      GetIt.I.registerSingleton(logService);
    });

    tearDownAll(() {
      logService = null;
      authState = null;
    });

    testWidgets("create widget with success", (tester) async {
      await tester.pumpLocalizedWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(),
          ),
        ),
      );

      expect(find.text("Email"), findsOneWidget);
      expect(find.text("Password"), findsOneWidget);
      expect(find.text("Log In"), findsOneWidget);
    });

    testWidgets("login with correct data", (tester) async {
      when(authState.login(any, any))
          .thenAnswer((realInvocation) async => Either.right(Unit()));
      await tester.pumpLocalizedWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider.value(
              value: authState,
              child: LoginForm(),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, "user@mail.com");
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).last, "mock_password");
      await tester.pumpAndSettle();
      await tester.tap(find.text("Log In"));
      await tester.pumpAndSettle();

      verify(logService.debug(any)).called(1);
      verify(authState.login(any, any)).called(1);
    });

    testWidgets("login with invalid data", (tester) async {
      when(authState.login(any, any))
          .thenAnswer((realInvocation) async => Either.right(Unit()));
      await tester.pumpLocalizedWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider.value(
              value: authState,
              child: LoginForm(),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, "user.com");
      await tester.pumpAndSettle();
      await tester.tap(find.text("Log In"));
      await tester.pumpAndSettle();

      expect(find.text("Email is not valid!"), findsOneWidget);
      expect(find.text("Password can't be empty!"), findsOneWidget);
      verifyNever(logService.debug(any));
      verifyNever(authState.login(any, any));
    });

    testWidgets("login with server error", (tester) async {
      when(authState.login(any, any)).thenAnswer((realInvocation) async =>
          Either.left(ServerFailure.unexpectedError("")));
      await tester.pumpLocalizedWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider.value(
              value: authState,
              child: LoginForm(),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, "user@mail.com");
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).last, "mock_password");
      await tester.pumpAndSettle();
      await tester.tap(find.text("Log In"));
      await tester.pumpAndSettle();

      expect(find.text("Error logging in!"), findsOneWidget);
      verify(logService.debug(any)).called(1);
      verify(authState.login(any, any)).called(1);
    });
  });
}
