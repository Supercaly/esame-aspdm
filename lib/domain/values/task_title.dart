import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/value_failure.dart';
import 'package:aspdm_project/core/value_object.dart';

/// Class representing a valid title.
class TaskTitle extends ValueObject<String> {
  static const int maxLength = 30;

  @override
  final Either<ValueFailure<String>, String> value;

  const TaskTitle._(this.value);

  /// Creates a [TaskTitle] from an input [String] that has
  /// at most [maxLength] characters.
  /// The input can't be null, empty or longer than [maxLength].
  factory TaskTitle(String input) {
    if (input == null || input.isEmpty || input.length > maxLength)
      return TaskTitle._(Either.left(ValueFailure(input)));
    return TaskTitle._(Either.right(input));
  }

  @override
  String toString() =>
      "TaskTitle(${value.fold((left) => left, (right) => right)})";
}
