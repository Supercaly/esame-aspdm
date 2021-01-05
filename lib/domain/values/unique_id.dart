import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/value_failure.dart';
import 'package:aspdm_project/core/value_object.dart';

/// Class representing an unique identifier used
/// by the entities in the app.
class UniqueId extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  const UniqueId._(this.value);

  /// Creates a [UniqueId] from a [String] id.
  /// If the id is `null` an [AssertionError] will be thrown.
  factory UniqueId(String id) {
    assert(id != null);
    return UniqueId._(Either.right(id));
  }

  @override
  String toString() => "UniqueId(${value.getOrNull()})";
}
