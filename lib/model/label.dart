import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Class representing a label.
/// A label is an information associated with a task
/// that has a [color] and a [text].
class Label extends Equatable {
  final Color color;
  final String text;

  Label(this.color, this.text);

  @override
  List<Object> get props => [color, text];
}
