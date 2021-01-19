import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("UniqueId tests", () {
    test("create id", () {
      final u1 = UniqueId("Mock Id");
      expect(u1.value.getOrCrash(), equals("Mock Id"));

      try {
        UniqueId(null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        UniqueId("");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("create empty id", () {
      final u1 = UniqueId.empty();
      expect(u1.value.isLeft(), isTrue);
    });

    test("to string returns the correct representation", () {
      expect(UniqueId("Mock Id").toString(), equals("UniqueId(Mock Id)"));
    });
  });
}
