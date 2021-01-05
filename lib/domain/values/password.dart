import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/value_failure.dart';
import 'package:aspdm_project/core/value_object.dart';

/// Class representing a valid password.
class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  const Password._(this.value);

  /// Creates a [Password] from a [String]
  /// password.
  /// The password can't be null or empty.
  factory Password(String pwd) {
    if (pwd == null || pwd.isEmpty)
      return Password._(Either.left(ValueFailure(pwd)));
    else
      return Password._(Either.right(pwd));
  }
}
