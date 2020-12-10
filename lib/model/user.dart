import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// Class representing a user using this app.
@JsonSerializable()
class User extends Equatable {
  /// Unique user identifier.
  @JsonKey(required: true, disallowNullValue: true)
  final String id;

  /// User's full name.
  @JsonKey(required: true, disallowNullValue: true)
  final String name;

  /// User's email address.
  @JsonKey(required: true, disallowNullValue: true)
  final String email;

  const User(this.id, this.name, this.email);

  /// Creates a new [User] from json data.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Converts this [User] to json data.
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object> get props => [id];

  @override
  String toString() => "User {id: $id, name: $name, email: $email}";
}
