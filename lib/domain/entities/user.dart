import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Class representing a user using this app.
class User extends Equatable {
  /// Unique user identifier.
  final UniqueId id;

  /// User's full name.
  final UserName name;

  /// User's email address.
  final EmailAddress email;

  /// User's profile color.
  final Color profileColor;

  const User({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.profileColor,
  });

  @override
  List<Object> get props => [id];

  @override
  String toString() => "User {id: $id, name: $name, email: $email, "
      "profileColor: $profileColor";
}
