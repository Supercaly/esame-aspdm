import 'package:aspdm_project/core/either.dart';
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

  /// Creates a [TaskTitle] with empty content.
  /// NOTE: The new [TaskTitle] will have value that is the left
  /// side of the Either (it's invalid).
  factory TaskTitle.empty() => TaskTitle._(Either.left(ValueFailure(null)));

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
      return TaskDescription._(Either.left(ValueFailure(input)));
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
    if (input == null || input.isEmpty || input.length > maxLength)
      return ChecklistTitle._(Either.left(ValueFailure(input)));
    return ChecklistTitle._(Either.right(input));
  }

  @override
  String toString() =>
      "ChecklistTitle(${value.fold((left) => left, (right) => right)})";
}

/// Class representing a valid item text.
class ItemText extends ValueObject<String> {
  // TODO(#49): Extend the max length of an ItemText
  static const int maxLength = 500;

  @override
  final Either<ValueFailure<String>, String> value;

  const ItemText._(this.value);

  /// Creates a [ItemText] from an input [String] that has
  /// at most [maxLength] characters.
  /// The input can't be null, empty or longer than [maxLength].
  factory ItemText(String input) {
    if (input == null || input.isEmpty || input.length > maxLength)
      return ItemText._(Either.left(ValueFailure(input)));
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
    if (content == null || content.isEmpty || content.length > maxLength)
      return CommentContent._(Either.left(ValueFailure(content)));
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
