import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/value_failure.dart';
import 'package:aspdm_project/core/value_object.dart';

/// Class representing a valid email address.
class EmailAddress extends ValueObject<String> {
  static const String _emailRegex =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";

  @override
  final Either<ValueFailure<String>, String> value;

  const EmailAddress._(this.value);

  /// Creates an [EmailAddress] from a [String] email.
  /// If the email is invalid this will have a value
  /// of type [ValueFailure].
  factory EmailAddress(String email) {
    if (email == null)
      return EmailAddress._(Either.left(ValueFailure(email)));
    else if (!RegExp(_emailRegex).hasMatch(email))
      return EmailAddress._(Either.left(ValueFailure(email)));
    else
      return EmailAddress._(Either.right(email));
  }

  @override
  String toString() => "EmailAddress(${value.getOrNull()})";
}
