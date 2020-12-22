import 'package:aspdm_project/utils/color_parser.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'label.g.dart';

/// Class representing a label.
/// A label is an information associated with a task
/// that has a [color] and a [text].
@JsonSerializable()
class Label extends Equatable {
  /// Id of the label.
  @JsonKey(
    name: "_id",
    required: true,
    disallowNullValue: true,
  )
  final String id;

  /// Color of the label.
  @JsonKey(
    required: true,
    disallowNullValue: true,
    fromJson: colorFromJson,
    toJson: colorToJson,
  )
  final Color color;

  /// Label's text.
  @JsonKey(nullable: true)
  final String text;

  Label(this.id, this.color, this.text);

  /// Creates a new [Label] from json data.
  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);

  /// Converts this [Label] to json data.
  Map<String, dynamic> toJson() => _$LabelToJson(this);

  @override
  List<Object> get props => [id];
}
