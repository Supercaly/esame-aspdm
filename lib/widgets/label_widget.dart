import 'package:aspdm_project/model/label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Widget displaying a single [Label] element.
class LabelWidget extends StatelessWidget {
  /// [Label] object to display.
  final Label label;

  /// If set to `true` the label will be displayed as
  /// a rectangular colored box; if set to `false` it
  /// will display the label's text inside that box.
  /// Defaults to `false`
  final bool compact;

  const LabelWidget({
    Key key,
    this.label,
    this.compact = false,
  })  : assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? 42.0 : 82.0,
      height: compact ? 10.0 : 32.0,
      //padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: label.color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: (!compact)
          ? Center(
              child: Text(
              label.text ?? "",
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
            ))
          : null,
    );
  }
}
