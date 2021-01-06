import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("TaskTitle tests", () {
    test("create task title", () {
      final u1 = TaskTitle("Mock Title");
      expect(u1.value.getOrCrash(), equals("Mock Title"));

      final longLine = StringBuffer();
      for (var i = 0; i < 50; i++) longLine.write("a");
      final u2 = TaskTitle(longLine.toString());
      expect(u2.value.isLeft(), isTrue);

      final u3 = TaskTitle(null);
      expect(u3.value.isLeft(), isTrue);

      final u4 = TaskTitle("");
      expect(u4.value.isLeft(), isTrue);
    });

    test("to string returns the correct representation", () {
      expect(
          TaskTitle("Mock Title").toString(), equals("TaskTitle(Mock Title)"));
      expect(TaskTitle(null).toString(), equals("TaskTitle(Failure{null})"));
    });
  });

  group("TaskDescription tests", () {
    test("create task description", () {
      final u1 = TaskDescription("Mock Description");
      expect(u1.value.getOrCrash(), equals("Mock Description"));

      final u2 = TaskDescription(null);
      expect(u2.value.isRight(), isTrue);
      expect(u2.value.getOrCrash(), isNull);

      final longLine = StringBuffer();
      for (var i = 0; i < 1500; i++) longLine.write("a");
      final u3 = TaskDescription(longLine.toString());
      expect(u3.value.isLeft(), isTrue);

      final u4 = TaskDescription("");
      expect(u4.value.isLeft(), isTrue);
    });

    test("to string returns the correct representation", () {
      expect(TaskDescription("Mock Description").toString(),
          equals("TaskDescription(Mock Description)"));

      final longLine = StringBuffer();
      for (var i = 0; i < 1500; i++) longLine.write("a");
      expect(TaskDescription(longLine.toString()).toString(),
          equals("TaskDescription(Failure{${longLine.toString()}})"));
    });
  });

  group("ItemText tests", () {
    test("create item text", () {
      final u1 = ItemText("Mock Item Title");
      expect(u1.value.getOrCrash(), equals("Mock Item Title"));

      final longLine = StringBuffer();
      for (var i = 0; i < 50; i++) longLine.write("a");
      final u2 = ItemText(longLine.toString());
      expect(u2.value.isLeft(), isTrue);

      final u3 = ItemText(null);
      expect(u3.value.isLeft(), isTrue);

      final u4 = ItemText("");
      expect(u4.value.isLeft(), isTrue);
    });

    test("to string returns the correct representation", () {
      expect(ItemText("Mock Item Title").toString(),
          equals("ItemText(Mock Item Title)"));
      expect(ItemText(null).toString(), equals("ItemText(Failure{null})"));
    });
  });

  group("CommentContent tests", () {
    test("create comment content", () {
      final u1 = CommentContent("Mock Content");
      expect(u1.value.getOrCrash(), equals("Mock Content"));

      final longLine = StringBuffer();
      for (var i = 0; i < 600; i++) longLine.write("a");
      final u2 = CommentContent(longLine.toString());
      expect(u2.value.isLeft(), isTrue);

      final u3 = CommentContent(null);
      expect(u3.value.isLeft(), isTrue);

      final u4 = CommentContent("");
      expect(u4.value.isLeft(), isTrue);
    });

    test("to string returns the correct representation", () {
      expect(CommentContent("Mock Content").toString(),
          equals("CommentContent(Mock Content)"));
      expect(CommentContent(null).toString(),
          equals("CommentContent(Failure{null})"));
    });
  });

  group("Toggle tests", () {
    test("create toggle", () {
      final u1 = Toggle(true);
      expect(u1.value.getOrCrash(), isTrue);

      final u2 = Toggle(false);
      expect(u2.value.getOrCrash(), isFalse);

      final u3 = Toggle(null);
      expect(u3.value.getOrCrash(), isFalse);
    });

    test("to string returns the correct representation", () {
      expect(Toggle(true).toString(), equals("Toggle(true)"));
      expect(Toggle(false).toString(), equals("Toggle(false)"));
    });
  });
}
