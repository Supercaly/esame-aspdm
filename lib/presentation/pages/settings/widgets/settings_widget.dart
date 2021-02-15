import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Widget that displays a custom group of settings,
class SettingsGroup extends StatelessWidget {
  /// Title of the group shown on top left corner.
  final String title;

  /// List of [SettingsGroupItem].
  final List<SettingsGroupItem> children;

  SettingsGroup({
    Key key,
    @required this.title,
    @required this.children,
  })  : assert(title != null),
        assert(children != null && children.isNotEmpty,
            "You must give at least one children!"),
        super(key: key);

  /// Creates a [SettingsGroup] with a single [SettingsGroupItem].
  factory SettingsGroup.single({
    Key key,
    @required String title,
    @required SettingsGroupItem item,
  }) =>
      SettingsGroup(
        key: key,
        title: title,
        children: [item],
      );

  @override
  Widget build(BuildContext context) {
    final titleWidget = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.caption,
      ),
    );

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [titleWidget]..addAll(children),
      ),
    );
  }
}

/// Widget that displays a single item of the settings.
class SettingsGroupItem extends StatelessWidget {
  /// Widget displayed as an icon.
  final Widget icon;

  /// Text displayed on the button.
  final String text;

  /// Callback called when the user taps on the item.
  final VoidCallback onTap;

  /// Callback called when the user long-presses the item.
  final VoidCallback onLongPress;

  /// Color of the text.
  final Color textColor;

  SettingsGroupItem({
    Key key,
    this.icon,
    @required this.text,
    this.onTap,
    this.onLongPress,
    this.textColor,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: InkWell(
        onLongPress: () => onLongPress?.call(),
        onTap: () => onTap?.call(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              (icon != null) ? icon : SizedBox(width: 24.0, height: 24.0),
              SizedBox(width: 16.0),
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
