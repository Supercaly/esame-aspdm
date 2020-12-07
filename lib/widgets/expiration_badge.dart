import 'package:aspdm_project/generated/gen_colors.g.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpirationBadge extends StatelessWidget {
  final DateTime date;

  ExpirationBadge({
    Key key,
    this.date,
  })  : assert(date != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    Color color;
    Color bgColor;

    if (date.toUtc().isBefore(now)) {
      // The task has expired
      color = Colors.white;
      bgColor = EasyColors.timeExpired;
    } else if (date.isBefore(now.add(Duration(days: 2)))) {
      // The task is about to expire in 2 days
      color = Colors.white;
      bgColor = EasyColors.timeExpiring;
    } else {
      // The task is not expired yet
      color = Color(0xFF666666);
    }

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time_outlined,
            color: color,
          ),
          SizedBox(width: 4.0),
          Text(
            DateFormat("dd MMM y").format(date),
            style: Theme.of(context).textTheme.caption.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
