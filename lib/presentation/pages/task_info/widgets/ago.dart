import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Widget used to display a [Text] with a [time] formatted in a
/// fuzzy way like 'a moment ago'.
class Ago extends StatelessWidget {
  /// The date to format in the form of [DateTime].
  /// If this is null [placeholder] will be displayed instead.
  final DateTime? time;

  /// The point of reference for calculating the elapsed time.
  final DateTime? clock;

  /// String used as a placeholder when [time] is `null`.
  final String? placeholder;

  /// [TextStyle] for the internal [Text] Widget.
  final TextStyle? style;

  const Ago({
    Key? key,
    this.time,
    this.clock,
    this.placeholder,
    this.style,
  }) : super(key: key);

  /// Returns a [String] based on the given [date] formatted in a
  /// fuzzy time like 'a moment ago'.
  ///
  /// - [date] to format expressed in the form of [DateTime.millisecondsSinceEpoch]
  /// - If [clock] is passed this will be the point of reference for calculating
  ///   the elapsed time. Defaults to DateTime.now()
  static String format(DateTime date, {DateTime? clock}) {
    final _clock = clock ?? DateTime.now();
    var elapsed = _clock.millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    String prefix, suffix;

    if (elapsed < 0) {
      elapsed = date.isBefore(_clock) ? elapsed : elapsed.abs();
      prefix = 'ago_prefix_from_now'.tr();
      suffix = 'ago_suffix_from_now'.tr();
    } else {
      prefix = 'ago_prefix_ago'.tr();
      suffix = 'ago_suffix_ago'.tr();
    }

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    String result;
    if (seconds < 45)
      result = 'ago_a_moment'.tr();
    else if (seconds < 90)
      result = 'ago_a_minute'.tr();
    else if (minutes < 45)
      result = 'ago_minutes'.tr(args: [minutes.round().toString()]);
    else if (minutes < 90)
      result = 'ago_an_hour'.tr();
    else if (hours < 24)
      result = 'ago_hours'.tr(args: [hours.round().toString()]);
    else if (hours < 48)
      result = 'ago_a_day'.tr();
    else if (days < 30)
      result = 'ago_days'.tr(args: [days.round().toString()]);
    else if (days < 60)
      result = 'ago_a_month'.tr();
    else if (days < 365)
      result = 'ago_months'.tr(args: [months.round().toString()]);
    else if (years < 2)
      result = 'ago_a_year'.tr();
    else
      result = 'ago_years'.tr(args: [years.round().toString()]);

    return [prefix, result, suffix]
        .where((str) => str.isNotEmpty)
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    if (time != null)
      return Text(
        format(time!, clock: clock),
        style: style,
      );
    return (placeholder != null) ? Text(placeholder!) : SizedBox.shrink();
  }
}
