import 'dart:math';

import 'package:aspdm_project/model/user.dart';
import 'package:flutter/material.dart';

/// Widget displaying a nice circle or rectangular
/// avatar for the given [user].
class UserAvatar extends StatefulWidget {
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
  _UserAvatarState createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  Color boxColor;

  @override
  void initState() {
    super.initState();

    // If the user doesn't have a profile color
    // pick one at random.
    if (widget.user?.profileColor != null)
      boxColor = widget.user.profileColor;
    else
      boxColor =
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    final userInitial = widget.user?.name?.substring(0, 1)?.toUpperCase() ?? "";
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: boxColor,
        shape: widget.rectangle ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: widget.rectangle ? BorderRadius.circular(8.0) : null,
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
