import 'package:tasky/domain/entities/label.dart';
import 'package:tasky/domain/values/label_values.dart';
import 'package:tasky/infrastructure/color_parser.dart';
import 'package:tasky/domain/values/unique_id.dart';
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

  LabelModel({
    @required this.id,
    @required this.color,
    @required this.label,
  });

  factory LabelModel.fromJson(Map<String, dynamic> json) =>
      _$LabelModelFromJson(json);

  Map<String, dynamic> toJson() => _$LabelModelToJson(this);

  factory LabelModel.fromDomain(Label label) => LabelModel(
        id: label.id.value.getOrNull(),
        color: label.color.value.getOrNull(),
        label: label.label.value.getOrNull(),
      );

  Label toDomain() => Label(
        id: UniqueId(id),
        color: LabelColor(color),
        label: LabelName(label),
      );

  @override
  List<Object> get props => [id, color, label];
}
