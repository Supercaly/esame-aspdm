import 'package:flutter/material.dart';

/// Widget that creates his child based on the current
/// device size.
class Responsive extends StatelessWidget {
  static const int _smallSize = 600;
  static const int _largeSize = 992;

  /// Widget displayed when the device is small.
  final Widget small;

  /// Widget displayed when the device is medium.
  final Widget? medium;

  /// Widget displayed when the device is large.
  final Widget large;

  /// Creates an instance of [Responsive] with a
  /// [small], [medium] and [large] widget.
  /// [medium] could be omitted.
  Responsive({
    Key? key,
    required this.small,
    this.medium,
    required this.large,
  })  : super(key: key);

  /// Returns `true` if the current device is small
  /// (a smartphone).
  static bool isSmall(BuildContext context) =>
      MediaQuery.of(context).size.width <= _smallSize;

  /// Returns `true` if the current device is medium
  /// (a tablet).
  static bool isMedium(BuildContext context) =>
      MediaQuery.of(context).size.width >= _smallSize &&
      MediaQuery.of(context).size.width <= _largeSize;

  /// Returns `true` if the current device is large
  /// (a desktop, laptop or more).
  static bool isLarge(BuildContext context) =>
      MediaQuery.of(context).size.width >= _largeSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth <= _smallSize)
        return small;
      else if (constraints.maxWidth < _largeSize)
        return medium ?? small;
      else
        return large;
    });
  }
}
