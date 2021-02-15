import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/infrastructure/color_parser.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';
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

  UserModel({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.profileColor,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromUser(User user) => UserModel(
        id: user.id.value.getOrNull(),
        name: user.name.value.getOrNull(),
        email: user.email.value.getOrNull(),
        profileColor: user.profileColor,
      );

  User toUser() => User(
        id: UniqueId(id),
        name: UserName(name),
        email: EmailAddress(email),
        profileColor: profileColor,
      );

  @override
  List<Object> get props => [id, name, email, profileColor];
}
