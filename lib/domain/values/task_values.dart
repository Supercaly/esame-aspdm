import 'package:tasky/core/either.dart';
import 'package:tasky/core/value_object.dart';

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
    if (input == null || input.isEmpty)
      return TaskTitle._(Either.left(ValueFailure.empty(input)));
    if (input.length > maxLength)
      return TaskTitle._(Either.left(ValueFailure.tooLong(input)));
    return TaskTitle._(Either.right(input));
  }

  /// Creates a [TaskTitle] with empty content.
  /// NOTE: The new [TaskTitle] will have value that is the left
  /// side of the Either (it's invalid).
  factory TaskTitle.empty() =>
      TaskTitle._(Either.left(ValueFailure.empty(null)));

  @override
  String toString() =>
      "TaskTitle(${value.fold((left) => left, (right) => right)})";
}

/// Class representing a valid description.
class TaskDescription extends ValueObject<String> {
  static const int maxLength = 1000;

  @override
  final Either<ValueFailure<String>, String> value;

  const TaskDescription._(this.value);

  /// Creates a [TaskDescription] from an input [String] that has
  /// at most [maxLength] characters.
  factory TaskDescription(String input) {
    if (input != null && input.length > maxLength)
      return TaskDescription._(Either.left(ValueFailure.tooLong(input)));
    return TaskDescription._(Either.right(input));
  }

  /// Creates a [TaskDescription] with empty content.
  factory TaskDescription.empty() => TaskDescription._(Either.right(""));

  @override
  String toString() =>
      "TaskDescription(${value.fold((left) => left, (right) => right)})";
}

/// Class representing a valid checklist title.
class ChecklistTitle extends ValueObject<String> {
  static const int maxLength = 30;

  final Either<ValueFailure<String>, String> value;

  const ChecklistTitle._(this.value);

  /// Creates a [ChecklistTitle] from an input [String] that has
  /// at most [maxLength] characters.
  /// The input can't be null, empty or longer than [maxLength].
  factory ChecklistTitle(String input) {
    if (input == null || input.isEmpty)
      return ChecklistTitle._(Either.left(ValueFailure.empty(input)));
    if (input.length > maxLength)
      return ChecklistTitle._(Either.left(ValueFailure.tooLong(input)));
    return ChecklistTitle._(Either.right(input));
  }

  @override
  String toString() =>
      "ChecklistTitle(${value.fold((left) => left, (right) => right)})";
}

/// Class representing a valid item text.
class ItemText extends ValueObject<String> {
  static const int maxLength = 500;

  @override
  final Either<ValueFailure<String>, String> value;

  const ItemText._(this.value);

  /// Creates a [ItemText] from an input [String] that has
  /// at most [maxLength] characters.
  /// The input can't be null, empty or longer than [maxLength].
  factory ItemText(String input) {
    if (input == null || input.isEmpty)
      return ItemText._(Either.left(ValueFailure.empty(input)));
    if (input.length > maxLength)
      return ItemText._(Either.left(ValueFailure.tooLong(input)));
    return ItemText._(Either.right(input));
  }

  @override
  String toString() =>
      "ItemText(${value.fold((left) => left, (right) => right)})";
}

/// Class representing the content of a comment.
class CommentContent extends ValueObject<String> {
  static const int maxLength = 500;

  @override
  final Either<ValueFailure<String>, String> value;

  const CommentContent._(this.value);

  /// Creates a [CommentContent] from a [String] content.
  /// The content can't be null, empty or more long than
  /// [maxLength].
  factory CommentContent(String content) {
    if (content == null || content.isEmpty)
      return CommentContent._(Either.left(ValueFailure.empty(content)));
    if (content.length > maxLength)
      return CommentContent._(Either.left(ValueFailure.tooLong(content)));
    return CommentContent._(Either.right(content));
  }

  @override
  String toString() =>
      "CommentContent(${value.fold((left) => left, (right) => right)})";
}

/// Class representing a toggle.
class Toggle extends ValueObject<bool> {
  @override
  final Either<ValueFailure<bool>, bool> value;

  const Toggle._(this.value);

  /// Creates a [Toggle] from a [bool] input.
  /// If the input is null `false` will be used instead.
  factory Toggle(bool input) => Toggle._(Either.right(input ?? false));

  @override
  String toString() =>
      "Toggle(${value.fold((left) => left, (right) => right)})";
}

/// Class representing a date when something was created.
class CreationDate extends ValueObject<DateTime> {
  @override
  final Either<ValueFailure<DateTime>, DateTime> value;

  const CreationDate._(this.value);

  /// Create a [CreationDate] from a [DateTime] input.
  /// The date can't be null.
  factory CreationDate(DateTime input) {
    if (input == null)
      return CreationDate._(Either.left(ValueFailure.empty(input)));
    return CreationDate._(Either.right(input));
  }

  @override
  String toString() =>
      "CreationDate(${value.fold((left) => left, (right) => right)})";
}

/// Class representing a task's expire date.
class ExpireDate extends ValueObject<DateTime> {
  @override
  final Either<ValueFailure<DateTime>, DateTime> value;

  const ExpireDate._(this.value);

  /// Create a [ExpireDate] from a [DateTime] input.
  /// The date can't be null.
  factory ExpireDate(DateTime input) {
    if (input == null)
      return ExpireDate._(Either.left(ValueFailure.empty(input)));
    return ExpireDate._(Either.right(input));
  }

  @override
  String toString() =>
      "ExpireDate(${value.fold((left) => left, (right) => right)})";
}
