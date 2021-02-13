import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';
import 'package:tasky/services/preference_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  SharedPreferences mockPreferences;
  PreferenceService service;

  test("get stored user", () async {
    SharedPreferences.setMockInitialValues({
      "user_id": null,
      "user_name": null,
      "user_email": null,
      "user_color": null,
    });
    service = PreferenceService();
    await service.init();

    Maybe<User> user = service.getLastSignedInUser();
    expect(user.isNothing(), isTrue);

    SharedPreferences.setMockInitialValues({
      "user_id": "mock_id",
      "user_name": "mock user",
      "user_email": "mock.user@email.com",
      "user_color": 0xFFFF0000,
    });
    service = PreferenceService();
    await service.init();

    user = service.getLastSignedInUser();
    expect(user.isJust(), isTrue);
    expect(
      user.getOrNull(),
      equals(
        User(
          UniqueId("mock_id"),
          UserName("mock user"),
          EmailAddress("mock.user@email.com"),
          Colors.red,
        ),
      ),
    );
  });

  test("store null user", () async {
    SharedPreferences.setMockInitialValues({
      "user_id": null,
      "user_name": null,
      "user_email": null,
      "user_color": null,
    });
    mockPreferences = await SharedPreferences.getInstance();
    service = PreferenceService();
    await service.init();

    expect(mockPreferences.getString("user_id"), isNull);
    expect(mockPreferences.getString("user_name"), isNull);
    expect(mockPreferences.getString("user_email"), isNull);
    expect(mockPreferences.getInt("user_color"), isNull);

    Maybe<User> user = service.getLastSignedInUser();
    expect(user.isNothing(), isTrue);

    await service.storeSignedInUser(Maybe.nothing());

    expect(mockPreferences.getString("user_id"), isNull);
    expect(mockPreferences.getString("user_name"), isNull);
    expect(mockPreferences.getString("user_email"), isNull);
    expect(mockPreferences.getInt("user_color"), isNull);
  });

  test("store real user", () async {
    SharedPreferences.setMockInitialValues({
      "user_id": null,
      "user_name": null,
      "user_email": null,
      "user_color": null,
    });
    mockPreferences = await SharedPreferences.getInstance();
    service = PreferenceService();
    await service.init();

    expect(mockPreferences.getString("user_id"), isNull);
    expect(mockPreferences.getString("user_name"), isNull);
    expect(mockPreferences.getString("user_email"), isNull);
    expect(mockPreferences.getInt("user_color"), isNull);

    Maybe<User> user = service.getLastSignedInUser();
    expect(user.isNothing(), isTrue);

    await service.storeSignedInUser(Maybe.just(User(
      UniqueId("mock_id"),
      UserName("mock user"),
      EmailAddress("mock.user@email.com"),
      Colors.yellow,
    )));

    expect(mockPreferences.getString("user_id"), equals("mock_id"));
    expect(mockPreferences.getString("user_name"), equals("mock user"));
    expect(
        mockPreferences.getString("user_email"), equals("mock.user@email.com"));
    expect(mockPreferences.getInt("user_color"), equals(Colors.yellow.value));
  });
}
