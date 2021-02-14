// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MaterialByColorFinder extends MatchFinder {
  final Color color;

  MaterialByColorFinder(this.color, {bool skipOffstage = true})
      : super(skipOffstage: skipOffstage);

  @override
  String get description => 'Material{color: "$color"}';

  @override
  bool matches(Element candidate) {
    if (candidate.widget is Material) {
      final Material materialWidget = candidate.widget;
      if (materialWidget.color == color) return true;
    }
    return false;
  }
}
