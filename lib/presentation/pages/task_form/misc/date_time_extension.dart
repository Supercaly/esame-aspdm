import 'package:flutter/material.dart';

/// Extension methods on [DateTime].
extension DateTimeX on DateTime {
  /// Returns a new [DateTime] combining the current with a [TimeOfDay].
  DateTime combine(TimeOfDay? time) => DateTime(
        year,
        month,
        day,
        time?.hour ?? 0,
        time?.minute ?? 0,
      );

  /// Returns a [TimeOfDay] from a [DateTime].
  TimeOfDay toTime() => TimeOfDay(hour: hour, minute: minute);
}
