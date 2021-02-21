import 'package:freezed_annotation/freezed_annotation.dart';
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
  final LabelColor color;

  /// Label's text.
  final LabelName label;

  /// Create a new [Label] with all his values.
  const Label({
    @required this.id,
    @required this.color,
    @required this.label,
  });

  /// Create a new [User] with some of his values.
  /// If a value is not specified a safe default
  /// will be used instead.
  @visibleForTesting
  factory Label.test({
    UniqueId id,
    LabelColor color,
    LabelName label,
  }) =>
      Label(
        id: id ?? UniqueId.empty(),
        color: color ?? LabelColor(null),
        label: label ?? LabelName.empty(),
      );

  @override
  List<Object> get props => [id];

  @override
  String toString() => "Label{id: $id, color: $color, label: $label}";
}
