import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("UniqueId tests", () {
    test("create id", () {
      final u1 = UniqueId("Mock Id");
      expect(u1.value.getOrCrash(), equals("Mock Id"));

      final u2 = UniqueId(null);
      expect(u2.value.isLeft(), isTrue);

      final u3 = UniqueId("");
      expect(u3.value.isLeft(), isTrue);
    });

    test("create empty id", () {
      final u1 = UniqueId.empty();
      expect(u1.value.isLeft(), isTrue);
    });

    test("to string returns the correct representation", () {
      expect(UniqueId("Mock Id").toString(), equals("UniqueId(Mock Id)"));
      expect(UniqueId(null).toString(), equals("UniqueId(ValueFailureInvalidId{null})"));
    });
  });
}
