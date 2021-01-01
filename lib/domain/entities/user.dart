import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Class representing a user using this app.
class User extends Equatable {
  /// Unique user identifier.
  final String id;

  /// User's full name.
  final String name;

  /// User's email address.
  final String email;

  final Color profileColor;

  const User(this.id, this.name, this.email, this.profileColor);

  @override
  List<Object> get props => [id];

  @override
  String toString() => "User {id: $id, name: $name, email: $email, "
      "profileColor: $profileColor";
}
