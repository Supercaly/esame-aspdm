import 'package:tasky/domain/values/label_values.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("LabelName tests", () {
    test("create label name", () {
      final u1 = LabelName("Mock Name");
      expect(u1.value.getOrCrash(), equals("Mock Name"));

      final longLine = StringBuffer();
      for (var i = 0; i < 50; i++) longLine.write("a");
      final u2 = LabelName(longLine.toString());
      expect(u2.value.isLeft(), isTrue);

      final u3 = LabelName(null);
      expect(u3.value.isLeft(), isTrue);

      final u4 = LabelName("");
      expect(u4.value.isLeft(), isTrue);
    });

    test("create empty label name", () {
      final u1 = LabelName.empty();
      expect(u1.value.isLeft(), isTrue);
    });

    test("to string returns the correct representation", () {
      expect(LabelName("Mock Name").toString(), equals("LabelName(Mock Name)"));
      expect(LabelName(null).toString(),
          equals("LabelName(ValueFailure<String>.empty(value: null))"));
      final longLine = StringBuffer();
      for (var i = 0; i < 50; i++) longLine.write("a");
      expect(LabelName(longLine.toString()).toString(),
          equals("LabelName(ValueFailure<String>.tooLong(value: ${longLine.toString()}))"));
    });
  });
}
