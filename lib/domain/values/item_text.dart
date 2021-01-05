import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/value_failure.dart';
import 'package:aspdm_project/core/value_object.dart';

/// Class representing a valid item text.
class ItemText extends ValueObject<String> {
  static const int maxLength = 20;

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
}
