import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/value_failure.dart';
import 'package:aspdm_project/core/value_object.dart';

/// Class representing a toggle.
class Toggle extends ValueObject<bool> {
  @override
  final Either<ValueFailure<bool>, bool> value;

  const Toggle._(this.value);

  /// Creates a [Toggle] from a [bool] input.
  /// If the input is null `false` will be used instead.
  factory Toggle(bool input) => Toggle._(Either.right(input ?? false));
}
