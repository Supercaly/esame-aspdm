import 'package:easy_localization/easy_localization.dart';
import 'package:tasky/presentation/generated/gen_colors.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/// Widget displaying a colored text and icon with
/// the task's expiration [date].
/// If the task is expired the text is colored
/// red, if it's about to expire in 2 days it's
/// colored yellow, otherwise it has the Theme's
/// text color.
class ExpirationText extends StatelessWidget {
  /// Task's expiration date.
  final DateTime date;

  ExpirationText({
    Key? key,
    required this.date,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toUtc();
    Color? color;

    if (date.toUtc().isBefore(now)) {
      // The task has expired
      color = EasyColors.timeExpired;
    } else if (date.isBefore(now.add(Duration(days: 2)))) {
      // The task is about to expire in 2 days
      color = EasyColors.timeExpiring;
    } else {
      // The task is not expired yet
      color = Theme.of(context).textTheme.caption?.color;
    }

    return ListTile(
      leading: Icon(FeatherIcons.calendar, color: color),
      title: Text(
        DateFormat("dd MMM y HH:mm").format(date),
        style: Theme.of(context).textTheme.caption?.copyWith(color: color),
      ),
    );
  }
}
