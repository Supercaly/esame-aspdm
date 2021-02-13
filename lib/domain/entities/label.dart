import 'package:tasky/domain/values/label_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Class representing a label.
/// A label is an information associated with a task
/// that has a [color] and a [label].
class Label extends Equatable {
  /// Id of the label.
  final UniqueId id;

  /// Color of the label.
  final Color color;

  /// Label's text.
  final LabelName label;

  Label(this.id, this.color, this.label);

  @override
  List<Object> get props => [id];

  @override
  String toString() => "Label{id: $id, color: $color, label: $label}";
}
