import 'package:aspdm_project/domain/values/password.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("create password from correct value", () {
    final id = Password("mock_password");

    expect(id.value.isRight(), isTrue);
    expect(id.value.getOrNull(), equals("mock_password"));
  });

  test("create password from null throws an error", () {
    try {
      Password(null);
    } catch (e) {
      expect(e, isA<AssertionError>());
    }
  });
}
