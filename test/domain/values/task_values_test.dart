import 'package:tasky/domain/values/task_values.dart';
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

    test("create empty task title", () {
      final u1 = TaskTitle.empty();
      expect(u1.value.isLeft(), isTrue);
    });

    test("to string returns the correct representation", () {
      expect(
          TaskTitle("Mock Title").toString(), equals("TaskTitle(Mock Title)"));
      expect(TaskTitle(null).toString(),
          equals("TaskTitle(ValueFailure<String>.empty(value: null))"));
      final longLine = StringBuffer();
      for (var i = 0; i < 50; i++) longLine.write("a");
      expect(
          TaskTitle(longLine.toString()).toString(),
          equals(
              "TaskTitle(ValueFailure<String>.tooLong(value: ${longLine.toString()}))"));
    });
  });

  group("TaskDescription tests", () {
    test("create task description", () {
      final u1 = TaskDescription("Mock Description");
      expect(u1.value.getOrCrash(), equals("Mock Description"));

      final u2 = TaskDescription(null);
      expect(u2.value.isLeft(), isTrue);

      final longLine = StringBuffer();
      for (var i = 0; i < 1500; i++) longLine.write("a");
      final u3 = TaskDescription(longLine.toString());
      expect(u3.value.isLeft(), isTrue);

      final u4 = TaskDescription("");
      expect(u4.value.isLeft(), isTrue);
    });

    test("create empty task description", () {
      final u1 = TaskDescription.empty();
      expect(u1.value.isLeft(), isTrue);
    });

    test("to string returns the correct representation", () {
      expect(TaskDescription("Mock Description").toString(),
          equals("TaskDescription(Mock Description)"));

      final longLine = StringBuffer();
      for (var i = 0; i < 1500; i++) longLine.write("a");
      expect(
          TaskDescription(longLine.toString()).toString(),
          equals(
              "TaskDescription(ValueFailure<String>.tooLong(value: ${longLine.toString()}))"));
    });
  });

  group("ItemText tests", () {
    test("create item text", () {
      final u1 = ItemText("Mock Item Title");
      expect(u1.value.getOrCrash(), equals("Mock Item Title"));

      final longLine = StringBuffer();
      for (var i = 0; i < 600; i++) longLine.write("a");
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
      expect(ItemText(null).toString(),
          equals("ItemText(ValueFailure<String>.empty(value: null))"));

      final longLine = StringBuffer();
      for (var i = 0; i < 600; i++) longLine.write("a");
      expect(
          ItemText(longLine.toString()).toString(),
          equals(
              "ItemText(ValueFailure<String>.tooLong(value: ${longLine.toString()}))"));
    });
  });

  group("ChecklistTitle tests", () {
    test("create checklist title", () {
      final u1 = ChecklistTitle("Mock Title");
      expect(u1.value.getOrCrash(), equals("Mock Title"));

      final longLine = StringBuffer();
      for (var i = 0; i < 50; i++) longLine.write("a");
      final u2 = ChecklistTitle(longLine.toString());
      expect(u2.value.isLeft(), isTrue);

      final u3 = ChecklistTitle(null);
      expect(u3.value.isLeft(), isTrue);

      final u4 = ChecklistTitle("");
      expect(u4.value.isLeft(), isTrue);
    });

    test("to string returns the correct representation", () {
      expect(ChecklistTitle("Mock Title").toString(),
          equals("ChecklistTitle(Mock Title)"));
      expect(ChecklistTitle(null).toString(),
          equals("ChecklistTitle(ValueFailure<String>.empty(value: null))"));
      final longLine = StringBuffer();
      for (var i = 0; i < 50; i++) longLine.write("a");
      expect(
          ChecklistTitle(longLine.toString()).toString(),
          equals(
              "ChecklistTitle(ValueFailure<String>.tooLong(value: ${longLine.toString()}))"));
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
          equals("CommentContent(ValueFailure<String>.empty(value: null))"));
      final longLine = StringBuffer();
      for (var i = 0; i < 600; i++) longLine.write("a");
      expect(
          CommentContent(longLine.toString()).toString(),
          equals(
              "CommentContent(ValueFailure<String>.tooLong(value: ${longLine.toString()}))"));
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
      expect(Toggle(null).toString(), equals("Toggle(false)"));
    });
  });

  group("CreationDate tests", () {
    test("create creation date", () {
      final u1 = CreationDate(DateTime.parse("2020-12-23"));
      expect(u1.value.getOrCrash(), equals(DateTime.parse("2020-12-23")));

      final u2 = CreationDate(null);
      expect(u2.value.isLeft(), isTrue);
    });
  });

  group("ExpireDate tests", () {
    test("create creation date", () {
      final u1 = ExpireDate(DateTime.parse("2020-12-23"));
      expect(u1.value.getOrCrash(), equals(DateTime.parse("2020-12-23")));

      final u2 = ExpireDate(null);
      expect(u2.value.isLeft(), isTrue);
    });
  });
}
