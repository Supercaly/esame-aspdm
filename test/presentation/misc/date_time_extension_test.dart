import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasky/presentation/misc/date_time_extension.dart';

void main() {
  group("DateTimeX test", () {
    test("combine return a new correct date", () {
      final d1 = DateTime(2012, 05, 15);
      final t1 = TimeOfDay(hour: 06, minute: 30);
      final d2 = d1.combine(t1);
      expect(d2.year, equals(d1.year));
      expect(d2.month, equals(d1.month));
      expect(d2.day, equals(d1.day));
      expect(d2.hour, equals(t1.hour));
      expect(d2.minute, equals(t1.minute));

      final d3 = DateTime(2012, 05, 15, 16, 25);
      final t2 = TimeOfDay(hour: 06, minute: 30);
      final d4 = d3.combine(t2);
      expect(d4.year, equals(d3.year));
      expect(d4.month, equals(d3.month));
      expect(d4.day, equals(d3.day));
      expect(d4.hour, isNot(equals(d3.hour)));
      expect(d4.hour, equals(t2.hour));
      expect(d4.minute, isNot(equals(d3.minute)));
      expect(d4.minute, equals(t2.minute));

      final d5 = DateTime(2015, 12, 20);
      final d6 = d5.combine(null);
      expect(d6.year, equals(d5.year));
      expect(d6.month, equals(d5.month));
      expect(d6.day, equals(d5.day));
      expect(d6.hour, equals(0));
      expect(d6.minute, equals(0));
    });

    test("to time returns a correct time of day", () {
      final d1 = DateTime(2012, 05, 15, 16, 25);
      final t1 = d1.toTime();
      expect(t1, isA<TimeOfDay>());
      expect(t1.hour, equals(16));
      expect(t1.minute, equals(25));

      final d2 = DateTime(2020);
      final t2 = d2.toTime();
      expect(t2, isA<TimeOfDay>());
      expect(t2.hour, equals(0));
      expect(t2.minute, equals(0));
    });
  });
}
