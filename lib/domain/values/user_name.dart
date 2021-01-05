import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/value_failure.dart';
import 'package:aspdm_project/core/value_object.dart';

/// Class representing a valid user name.
class UserName extends ValueObject<String> {
  static const int maxLength = 256;

  @override
  final Either<ValueFailure<String>, String> value;

  const UserName._(this.value);

  /// Creates a [UserName] from an input [String] that has
  /// at most [maxLength] characters.
  /// If the input is null [AssertionError] will be thrown.
  factory UserName(String input) {
    assert(input != null);
    if (input.length > maxLength)
      return UserName._(Either.left(ValueFailure(input)));
    return UserName._(Either.right(input));
  }

  @override
  String toString() =>
      "UserName(${value.fold((left) => left, (right) => right)})";
}
