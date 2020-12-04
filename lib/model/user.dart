import 'package:equatable/equatable.dart';

/// Class representing a user using this app.
class User extends Equatable {
  /// Unique user identifier.
  final String id;

  /// User's full name.
  final String name;

  /// User's email address.
  final String email;

  User({this.id, this.name, this.email});

  @override
  List<Object> get props => [id];
}
