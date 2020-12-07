import 'package:aspdm_project/model/user.dart';
import 'package:aspdm_project/services/preference_service.dart';
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
    });
    mockPreferences = await SharedPreferences.getInstance();
    service = PreferenceService.private(mockPreferences);
    await service.init();

    User user = service.getLastSignedInUser();
    expect(user, isNull);

    SharedPreferences.setMockInitialValues({
      "user_id": "mock_id",
      "user_name": "mock user",
      "user_email": "mock.user@email.com",
    });
    mockPreferences = await SharedPreferences.getInstance();
    service = PreferenceService.private(mockPreferences);
    await service.init();

    user = service.getLastSignedInUser();
    expect(
      user,
      equals(
        User(
          id: "mock_id",
          name: "mock user",
          email: "mock.user@email.com",
        ),
      ),
    );
  });

  test("store null user", () async {
    SharedPreferences.setMockInitialValues({
      "user_id": null,
      "user_name": null,
      "user_email": null,
    });
    mockPreferences = await SharedPreferences.getInstance();
    service = PreferenceService.private(mockPreferences);
    await service.init();

    expect(mockPreferences.getString("user_id"), isNull);
    expect(mockPreferences.getString("user_name"), isNull);
    expect(mockPreferences.getString("user_email"), isNull);

    User user = service.getLastSignedInUser();
    expect(user, isNull);

    await service.storeSignedInUser(null);

    expect(mockPreferences.getString("user_id"), isNull);
    expect(mockPreferences.getString("user_name"), isNull);
    expect(mockPreferences.getString("user_email"), isNull);
  });

  test("store real user", () async {
    SharedPreferences.setMockInitialValues({
      "user_id": null,
      "user_name": null,
      "user_email": null,
    });
    mockPreferences = await SharedPreferences.getInstance();
    service = PreferenceService.private(mockPreferences);
    await service.init();

    expect(mockPreferences.getString("user_id"), isNull);
    expect(mockPreferences.getString("user_name"), isNull);
    expect(mockPreferences.getString("user_email"), isNull);

    User user = service.getLastSignedInUser();
    expect(user, isNull);

    await service.storeSignedInUser(User(
      id: "mock_id",
      name: "mock user",
      email: "mock.user@email.com",
    ));

    expect(mockPreferences.getString("user_id"), equals("mock_id"));
    expect(mockPreferences.getString("user_name"), equals("mock user"));
    expect(
        mockPreferences.getString("user_email"), equals("mock.user@email.com"));
  });
}
