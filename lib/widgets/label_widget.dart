import 'package:aspdm_project/model/label.dart';
import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  final Label label;

  const LabelWidget(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.0,
      height: 10.0,
      decoration: BoxDecoration(
        color: label.color,
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
