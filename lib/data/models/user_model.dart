import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/data/color_parser.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/domain/values/user_values.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  @JsonKey(name: "_id", required: true, disallowNullValue: true)
  final String id;

  @JsonKey(required: true, disallowNullValue: true)
  final String name;

  @JsonKey(required: true, disallowNullValue: true)
  final String email;

  @JsonKey(
    name: "profile_color",
    toJson: colorToJson,
    fromJson: colorFromJson,
  )
  final Color profileColor;

  UserModel(this.id, this.name, this.email, this.profileColor);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromUser(User user) => UserModel(
        user.id.value.getOrNull(),
        user.name.value.getOrNull(),
        user.email.value.getOrNull(),
        user.profileColor,
      );

  User toUser() =>
      User(UniqueId(id), UserName(name), EmailAddress(email), profileColor);

  @override
  List<Object> get props => [id, name, email, profileColor];
}
