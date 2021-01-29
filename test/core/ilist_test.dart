import 'package:aspdm_project/core/ilist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("IList test", () {
    test("create an empty list", () {
      final l = IList.empty();
      expect(l.isEmpty, isTrue);
    });

    test("create a list form an iterable", () {
      final l = IList.from([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      expect(l.isNotEmpty, isTrue);
      expect(l.length, equals(10));
      expect(l.asList(), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);

      final it = [1, 2, 3];
      final l2 = IList.from(it);
      expect(it, equals([1, 2, 3]));
      expect(l2.asList(), equals([1, 2, 3]));
      it.add(4);
      expect(it, equals([1, 2, 3, 4]));
      expect(l2.asList(), equals([1, 2, 3]));
    });

    test("create an empty ValueIList throws an error", () {
      try {
        ValueIList(null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        ValueIList([]);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("length returns the size of the list", () {
      final l = IList.from([0, 1, 2, 3]);
      expect(l.length, equals(4));

      final l3 = IList.empty();
      expect(l3.length, equals(0));
    });

    test("isEmpty/isNonEmpty returns correctly", () {
      final l = IList.from([0, 1, 2, 3]);
      expect(l.isEmpty, isFalse);
      expect(l.isNotEmpty, isTrue);

      final l2 = IList.empty();
      expect(l2.isEmpty, isTrue);
      expect(l2.isNotEmpty, isFalse);
    });

    test("get operator returns the correct element of the list", () {
      final l = IList.from([1, 2, 3, 4]);
      expect(l[0], equals(1));
      expect(l[1], equals(2));
      expect(l[2], equals(3));
      expect(l[3], equals(4));

      try {
        final v = l[5];
        print(v);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<IndexOutOfBoundsException>());
      }

      final l2 = IList.empty();
      try {
        final v = l2[0];
        print(v);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<IndexOutOfBoundsException>());
      }
    });

    test("contains returns correctly", () {
      final l = IList.from(["0", "1", "2", "3"]);
      expect(l.contains("0"), isTrue);
      expect(l.contains("1"), isTrue);
      expect(l.contains("2"), isTrue);
      expect(l.contains("3"), isTrue);
      expect(l.contains("5"), isFalse);

      final l3 = IList.empty();
      expect(l3.contains("0"), isFalse);
    });

    test("append returns a new list with an added element", () {
      final l1 = IList.from(["0", "1", "2", "3"]);
      final l2 = l1.append("4");
      expect(l1 == l2, isFalse);
      expect(l2[0], equals("0"));
      expect(l2[1], equals("1"));
      expect(l2[2], equals("2"));
      expect(l2[3], equals("3"));
      expect(l2[4], equals("4"));

      final l3 = IList.empty();
      final l4 = l3.append("0");
      expect(l3 == l4, isFalse);
      expect(l4[0], equals("0"));
    });

    test("patch returns a new list with the item replaced", () {
      final l1 = IList.from(["0", "1", "2", "3"]);
      final l2 = l1.patch("2", "5");
      expect(l1 == l2, isFalse);
      expect(l2, isA<IList<String>>());
      expect(l2.contains("2"), isFalse);
      expect(l2.contains("5"), isTrue);

      final l3 = IList.from(["0", "1", "2", "3"]);
      final l4 = l3.patch("5", "6");
      expect(l3 == l4, isTrue);
      expect(l4, isA<IList<String>>());
      expect(l4.contains("5"), isFalse);
      expect(l4.contains("6"), isFalse);

      final l5 = IList.from(["0", "1", "2", "3", "1"]);
      final l6 = l5.patch("1", "5");
      expect(l5 == l6, isFalse);
      expect(l6, isA<IList<String>>());
      expect(l6[1], equals("5"));
      expect(l6[4], equals("1"));

      final l7 = IList<String>.empty();
      final l8 = l7.patch("1", "5");
      expect(l7 == l8, isTrue);
      expect(l8, isA<IList<String>>());
      expect(l8.contains("1"), isFalse);
      expect(l8.contains("5"), isFalse);
    });

    test("remove returns a new list without the item", () {
      final l1 = IList.from(["0", "1", "2", "3"]);
      final l2 = l1.remove("2");
      expect(l1 == l2, isFalse);
      expect(l2, isA<IList<String>>());
      expect(l2.contains("2"), isFalse);

      final l3 = IList.from(["0", "1", "2", "3"]);
      final l4 = l3.remove("5");
      expect(l3 == l4, isTrue);
      expect(l4, isA<IList<String>>());
      expect(l4.contains("5"), isFalse);

      final l5 = IList.from(["0", "1", "2", "3", "1"]);
      final l6 = l5.remove("1");
      expect(l5 == l6, isFalse);
      expect(l6, isA<IList<String>>());
      expect(l6[1], equals("2"));
      expect(l6.contains("1"), isTrue);

      final l7 = IList<String>.empty();
      final l8 = l7.remove("1");
      expect(l7 == l8, isTrue);
      expect(l8, isA<IList<String>>());
      expect(l8.contains("1"), isFalse);

      final l9 = IList.from(["1"]);
      final l10 = l9.remove("1");
      expect(l9 == l10, isFalse);
      expect(l10, isA<IList<String>>());
      expect(l10.isEmpty, isTrue);
    });

    test("map returns a new list", () {
      final l1 = IList.from([0, 1, 2, 3]);
      final l2 = l1.map((element) => element.toString());
      expect(l2, isA<IList<String>>());
      expect(l2[0], equals("0"));
      expect(l2[1], equals("1"));
      expect(l2[2], equals("2"));
      expect(l2[3], equals("3"));

      final l3 = IList.empty();
      final l4 = l3.map((element) => element.toString());
      expect(l4, isA<IList<String>>());
      expect(l4.isEmpty, isTrue);
    });

    test("map indexed returns a new list", () {
      final l1 = IList.from([4, 5, 6, 7]);
      final l2 = l1.mapIndexed((i, e) => "$i $e");
      expect(l2, isA<IList<String>>());
      expect(l2[0], equals("0 4"));
      expect(l2[1], equals("1 5"));
      expect(l2[2], equals("2 6"));
      expect(l2[3], equals("3 7"));

      final l3 = IList.empty();
      final l4 = l3.mapIndexed((i, e) => "$i $e");
      expect(l4, isA<IList<String>>());
      expect(l4.isEmpty, isTrue);
    });

    test("filter returns a new list", () {
      final l1 = IList.from(["0", "1", "2", "1"]);
      final l2 = l1.filter((element) => element == "1");
      expect(l2, isA<IList<String>>());
      expect(l2.length, equals(2));
      expect(l2.asList(), equals(["1", "1"]));

      final l3 = IList<String>.empty();
      final l4 = l3.filter((element) => element == "1");
      expect(l4, isA<IList<String>>());
      expect(l4.isEmpty, isTrue);

      final l5 = IList.from(["0", "1", "2", "1"]);
      final l6 = l5.filter((element) => element == "3");
      expect(l6, isA<IList<String>>());
      expect(l6.isEmpty, isTrue);
    });

    test("for each loops all the elements in the list", () {
      final IList<int> list = IList.from([1, 2, 3, 4]);
      int idx = 0;
      list.forEach((element) {
        expect(list[idx], equals(element));
        idx++;
      });
      expect(idx, equals(list.length));

      final IList<int> empty = IList.empty();
      int idx2 = 0;
      empty.forEach((element) {
        expect(empty[idx2], equals(element));
        idx2++;
      });
      expect(idx2, equals(0));
    });

    test("IList can be used in a for-loop", () {
      final IList<int> list = IList.from([1, 2, 3, 4]);
      int idx = 0;
      for (int i in list.iterator) {
        expect(list[idx], equals(i));
        idx++;
      }
      expect(idx, equals(list.length));

      final IList<int> empty = IList.empty();
      int idx2 = 0;
      for (int i in empty.iterator) {
        expect(empty[idx2], equals(i));
        idx2++;
      }
      expect(idx2, equals(0));
    });

    test("to string returns the correct representation", () {
      expect(IList.empty().toString(), equals("[]"));
      expect(IList.from([1, 2, 3, 4]).toString(), equals("[1, 2, 3, 4]"));
    });

    test("as list returns a valid dart list", () {
      final l1 = IList<int>.empty();
      expect(l1.asList(), isA<List<int>>());
      expect(l1.asList(), isEmpty);

      final l2 = IList.from([1, 2, 3, 4]);
      expect(l2.asList(), isA<List<int>>());
      expect(l2.asList(), isNotEmpty);
      expect(l2.asList(), equals([1, 2, 3, 4]));
    });

    test("equality works correctly", () {
      final l1 = IList.from([1, 2, 3]);
      final l2 = IList.empty();
      final l3 = IList.from([4, 5, 6, 7]);
      final l4 = IList.from([4, 5, 6]);
      final l5 = IList.from([1, 2, 4]);

      expect(l1 == l1, isTrue);
      expect(l1 == l2, isFalse);
      expect(l1 == l3, isFalse);
      expect(l1 == l4, isFalse);
      expect(l1 == l5, isFalse);

      expect(l2 == l1, isFalse);
      expect(l2 == l2, isTrue);
    });

    test("hash code works correctly", () {
      final l1 = IList.from([1, 2, 3]);
      final l2 = IList.from([1, 2, 3]);
      final l3 = IList.from([4, 5, 6, 7]);
      final l4 = IList.from([4, 5, 6]);
      final l5 = IList.empty();

      expect(l1.hashCode == l1.hashCode, isTrue);
      expect(l1.hashCode == l2.hashCode, isTrue);
      expect(l1.hashCode == l3.hashCode, isFalse);
      expect(l1.hashCode == l4.hashCode, isFalse);
      expect(l1.hashCode == l5.hashCode, isFalse);

      expect(l2.hashCode == l1.hashCode, isTrue);
      expect(l2.hashCode == l2.hashCode, isTrue);
      expect(l2.hashCode == l3.hashCode, isFalse);
      expect(l2.hashCode == l4.hashCode, isFalse);
      expect(l2.hashCode == l5.hashCode, isFalse);

      expect(l3.hashCode == l1.hashCode, isFalse);
      expect(l3.hashCode == l2.hashCode, isFalse);
      expect(l3.hashCode == l3.hashCode, isTrue);
      expect(l3.hashCode == l4.hashCode, isFalse);
      expect(l3.hashCode == l5.hashCode, isFalse);

      expect(l4.hashCode == l1.hashCode, isFalse);
      expect(l4.hashCode == l2.hashCode, isFalse);
      expect(l4.hashCode == l3.hashCode, isFalse);
      expect(l4.hashCode == l4.hashCode, isTrue);
      expect(l4.hashCode == l5.hashCode, isFalse);

      expect(l5.hashCode == l1.hashCode, isFalse);
      expect(l5.hashCode == l2.hashCode, isFalse);
      expect(l5.hashCode == l3.hashCode, isFalse);
      expect(l5.hashCode == l4.hashCode, isFalse);
      expect(l5.hashCode == l5.hashCode, isTrue);
    });
  });
}
