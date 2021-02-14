import 'package:tasky/core/either.dart';
import 'package:tasky/core/value_object.dart';

/// Class representing a valid label name.
class LabelName extends ValueObject {
  static const int maxLength = 30;

  @override
  final Either<ValueFailure, dynamic> value;

  const LabelName._(this.value);

  /// Creates a [LabelName] from an input [String] that has
  /// at most [maxLength] characters.
  /// The input can't be null, empty or longer than [maxLength].
  factory LabelName(String? input) {
    if (input == null || input.isEmpty)
      return LabelName._(Either.left(ValueFailure.empty(input)));
    if (input.length > maxLength)
      return LabelName._(Either.left(ValueFailure.tooLong(input)));
    return LabelName._(Either.right(input));
  }

  /// Creates a [LabelName] with empty content.
  /// NOTE: The new [LabelName] will have value that is the left
  /// side of the Either (it's invalid).
  factory LabelName.empty() =>
      LabelName._(Either.left(ValueFailure.empty(null)));

  @override
  String toString() =>
      "LabelName(${value.fold((left) => left, (right) => right)})";
}
