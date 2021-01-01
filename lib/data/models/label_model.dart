import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/utils/color_parser.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'label_model.g.dart';

@JsonSerializable()
class LabelModel {
  @JsonKey(
    name: "_id",
    required: true,
    disallowNullValue: true,
  )
  final String id;

  @JsonKey(
    required: true,
    disallowNullValue: true,
    fromJson: colorFromJson,
    toJson: colorToJson,
  )
  final Color color;

  @JsonKey(nullable: true)
  final String label;

  LabelModel(this.id, this.color, this.label);

  factory LabelModel.fromJson(Map<String, dynamic> json) =>
      _$LabelModelFromJson(json);

  Map<String, dynamic> toJson() => _$LabelModelToJson(this);

  factory LabelModel.fromLabel(Label label) => LabelModel(
        label.id,
        label.color,
        label.label,
      );

  Label toLabel() => Label(id, color, label);
}
