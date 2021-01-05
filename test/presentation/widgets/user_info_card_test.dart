import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/values/email_address.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/domain/values/user_name.dart';
import 'package:aspdm_project/presentation/states/auth_state.dart';
import 'package:aspdm_project/presentation/widgets/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../finders/container_by_color_finder.dart';
import '../../mocks/mock_auth_state.dart';

void main() {
  AuthState state;

  setUpAll(() {
    state = MockAuthState();

    when(state.currentUser).thenReturn(User(
      UniqueId("mock_id"),
      UserName("Mock User"),
      EmailAddress("mock.user@email.com"),
      Colors.green,
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
    expect(ContainerByColorFinder(Colors.green), findsOneWidget);
  });
}
