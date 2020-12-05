import 'package:aspdm_project/model/user.dart';
import 'package:aspdm_project/states/auth_state.dart';
import 'package:aspdm_project/widgets/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mocks/mock_auth_state.dart';

void main() {
  AuthState state;

  setUpAll(() {
    state = MockAuthState();

    when(state.currentUser).thenReturn(User(
      id: "mock_id",
      name: "Mock User",
      email: "mock.user@email.com",
    ));
  });

  tearDownAll(() {
    state = null;
  });

  testWidgets("displayed correctly", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<AuthState>.value(
            value: state,
            child: UserInfoCard(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("M"), findsOneWidget);
    expect(find.text("Mock User"), findsOneWidget);
    expect(find.text("mock.user@email.com"), findsOneWidget);
  });
}
