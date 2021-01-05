import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/value_failure.dart';
import 'package:aspdm_project/core/value_object.dart';

/// Class representing a valid description.
class TaskDescription extends ValueObject<String> {
  static const int _maxLength = 1000;

  @override
  final Either<ValueFailure<String>, String> value;

  const TaskDescription._(this.value);

  /// Creates a [TaskDescription] from an input [String] that has
  /// at most [_maxLength] characters.
  factory TaskDescription(String input) {
    if (input != null && input.length > _maxLength)
      return TaskDescription._(Either.left(ValueFailure(input)));
    return TaskDescription._(Either.right(input));
  }

  @override
  String toString() =>
      "TaskDescription(${value.fold((left) => left, (right) => right)})";
}
