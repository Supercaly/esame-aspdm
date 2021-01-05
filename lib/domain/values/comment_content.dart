import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/value_failure.dart';
import 'package:aspdm_project/core/value_object.dart';

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
}
