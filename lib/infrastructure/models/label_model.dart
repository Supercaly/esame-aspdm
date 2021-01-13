import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/infrastructure/color_parser.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'label_model.g.dart';

@JsonSerializable()
class LabelModel extends Equatable {
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
        label.id.value.getOrNull(),
        label.color,
        label.label,
      );

  Label toLabel() => Label(UniqueId(id), color, label);

  @override
  List<Object> get props => [id, color, label];
}
