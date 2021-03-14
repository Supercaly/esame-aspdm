import 'package:tasky/domain/values/user_values.dart';
import 'failures.dart';

/// Represent a [Failure] with invalid user.
class InvalidUserFailure extends Failure {
  final EmailAddress email;
  final Password password;

  InvalidUserFailure({required this.email, required this.password});

  @override
  String toString() => "InvalidUserFailure{email: $email, password: $password}";
}
