import 'package:flutter/foundation.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';
import 'package:equatable/equatable.dart';

/// Class representing a user using this app.
class User extends Equatable {
  /// Unique user identifier.
  final UniqueId id;

  /// User's full name.
  final UserName name;

  /// User's email address.
  final EmailAddress email;

  /// User's profile color.
  final Maybe<ProfileColor> profileColor;

  /// Create a new [User] from all his values.
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileColor,
  });

  /// Create an empty [User].
  /// Note: The user created this way has all
  /// fields invalid, so be careful when using!
  factory User.empty() => User(
        id: UniqueId.empty(),
        name: UserName(null),
        email: EmailAddress(null),
        profileColor: Maybe.just(ProfileColor(null)),
      );

  /// Create a new [User] with some of his values.
  /// If a value is not specified a safe default
  /// will be used instead.
  @visibleForTesting
  factory User.test({
    UniqueId? id,
    UserName? name,
    EmailAddress? email,
    Maybe<ProfileColor>? profileColor,
  }) =>
      User(
        id: id ?? UniqueId.empty(),
        name: name ?? UserName(null),
        email: email ?? EmailAddress(null),
        profileColor: profileColor ?? Maybe.nothing(),
      );

  @override
  List<Object> get props => [id];

  @override
  String toString() => "User {id: $id, name: $name, email: $email, "
      "profileColor: $profileColor}";
}
