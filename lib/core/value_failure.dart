class ValueFailure<T> {
  final T _value;

  const ValueFailure(this._value);

  T get value => _value;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValueFailure<T> && other.value == this.value;
  }

  @override
  int get hashCode => value.hashCode;
}
