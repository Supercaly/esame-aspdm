import 'package:flutter/material.dart';

class ExpirationBadge extends StatelessWidget {
  final DateTime expireDate;
  final int _state;

  ExpirationBadge(this.expireDate) : _state = _checkDate(expireDate.toUtc());

  // TODO: Check the time on each rebuild
  static int _checkDate(DateTime expDate) {
    final now = DateTime.now().toUtc();

    if (expDate.isAfter(now.add(Duration(days: 4))))
      return 2;
    else if (expDate.isAfter(now))
      return 1;
    else
      return 0;
  }

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color boxColor;

    // TODO: Fix This time conversion
    if (_state == 0) {
      textColor = Colors.white;
      boxColor = Colors.red;
    } else if (_state == 1) {
      textColor = Colors.white;
      boxColor = Colors.deepOrange;
    } else {
      textColor = Color(0xFF666666);
    }

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time_outlined,
            color: textColor,
          ),
          SizedBox(width: 4.0),
          Text(
            "30 nov.",
            style:
                Theme.of(context).textTheme.caption.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
