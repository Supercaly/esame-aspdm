// @dart=2.9
import 'package:tasky/domain/values/user_values.dart';

/// Class representing a general failure.
/// A failure is not an error nor an exception.
abstract class Failure {}

/// Represent a [Failure] with invalid user.
class InvalidUserFailure extends Failure {
  final EmailAddress email;
  final Password password;

  InvalidUserFailure({this.email, this.password});

  @override
  String toString() => "InvalidUserFailure{email: $email, password: $password}";
}
