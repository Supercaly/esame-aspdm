import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/application/bloc/auth_bloc.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';
import 'package:tasky/presentation/pages/settings/widgets/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../finders/container_by_color_finder.dart';
import '../../../../mocks/mock_auth_bloc.dart';

void main() {
  AuthBloc authBloc;

  setUpAll(() {
    authBloc = MockAuthBloc();

    when(authBloc.state).thenReturn(AuthState.authenticated(
      Maybe.just(
        User.test(
          id: UniqueId("mock_id"),
          name: UserName("Mock User"),
          email: EmailAddress("mock.user@email.com"),
          profileColor: Maybe.just(ProfileColor(Colors.green)),
        ),
      ),
    ));
  });

  tearDownAll(() {
    authBloc = null;
  });

  testWidgets("displayed correctly", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AuthBloc>.value(
            value: authBloc,
            child: UserInfoCard(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("M"), findsOneWidget);
    expect(find.text("Mock User"), findsOneWidget);
    expect(find.text("mock.user@email.com"), findsOneWidget);
    expect(ContainerByColorFinder(Colors.green), findsOneWidget);
  });
}
