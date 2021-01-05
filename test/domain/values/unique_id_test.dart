import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("create id from correct value", () {
    final id = UniqueId("mock_id");

    expect(id.value.isRight(), isTrue);
    expect(id.value.getOrNull(), equals("mock_id"));
  });

  test("create id from null throws an error", () {
    try {
      UniqueId(null);
    } catch (e) {
      expect(e, isA<AssertionError>());
    }
  });
}
