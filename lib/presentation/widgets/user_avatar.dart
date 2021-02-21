import 'dart:math';

import 'package:tasky/domain/entities/user.dart';
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
    @required this.user,
    @required this.size,
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
    boxColor = widget.user?.profileColor?.value?.getOrNull() ??
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  @override
  void didUpdateWidget(covariant UserAvatar oldWidget) {
    // This widget now has a different user
    if (oldWidget.user != widget.user) {
      // Change the boxColor with the new user's color
      boxColor = widget.user?.profileColor?.value?.getOrNull() ??
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final userInitial =
        widget.user?.name?.value?.getOrNull()?.substring(0, 1)?.toUpperCase() ??
            "";
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
