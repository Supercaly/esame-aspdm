import 'dart:math';

import 'package:aspdm_project/model/user.dart';
import 'package:flutter/material.dart';

/// Widget displaying a nice circle or rectangular
/// avatar for the given [user].
class UserAvatar extends StatelessWidget {
  /// User to display.
  final User user;

  /// Size of the widget.
  final double size;

  /// If `true` will display as a rounded rectangle
  /// otherwise it will be displayed as a circle.
  final bool rectangle;

  UserAvatar({
    Key key,
    this.user,
    this.size,
    this.rectangle = false,
  })  : assert(size != null && size > 0.0),
        assert(rectangle != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInitial = user?.name?.substring(0, 1)?.toUpperCase() ?? "";
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
        shape: rectangle ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: rectangle ? BorderRadius.circular(8.0) : null,
      ),
      child: Center(
        child: Text(
          userInitial,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
