import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/utils/color_parser.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
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
        user.id,
        user.name,
        user.email,
        user.profileColor,
      );

  User toUser() => User(id, name, email, profileColor);
}
