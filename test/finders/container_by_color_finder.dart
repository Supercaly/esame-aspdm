import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class ContainerByColorFinder extends MatchFinder {
  final Color color;

  ContainerByColorFinder(this.color, {bool skipOffstage = true})
      : super(skipOffstage: skipOffstage);

  @override
  String get description => 'Container{color: "$color"}';

  @override
  bool matches(Element candidate) {
    if (candidate.widget is Container) {
      final Container containerWidget = candidate.widget as Container;
      if (containerWidget.color == color)
        return true;
      else if (containerWidget.decoration is BoxDecoration) {
        final BoxDecoration decoration = containerWidget.decoration as BoxDecoration;
        return decoration.color == color;
      }
    }
    return false;
  }
}
