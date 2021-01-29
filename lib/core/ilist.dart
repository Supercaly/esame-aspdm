/// Class that represent an immutable list of
/// elements [E].
/// This class has methods to work with his elements
/// without changing them (returning always a new list).
abstract class IList<E> {
  /// Creates an empty [IList].
  const factory IList.empty() = EmptyIList<E>;

  /// Creates an [IList] from a given [Iterable].
  factory IList.from(Iterable<E> elements) {
    if (elements == null || elements.isEmpty) return EmptyIList<E>();
    return ValueIList(elements);
  }

  /// The length (number of elements) of the list.
  int get length;

  /// Tests whether the list is empty.
  bool get isEmpty;

  /// Tests whether the list is not empty.
  bool get isNotEmpty;

  /// Tests whether this list contains a given value as an element.
  bool contains(E element);

  /// Returns the element at position [index].
  /// If [index] is outside the bound of the list it will throw
  /// [IndexOutOfBoundsException].
  E operator [](int index);

  /// Returns a copy of this list with an element appended
  IList<E> append(E element);

  /// Builds a new list by applying a function to all elements of this list.

  IList<T> map<T>(T f(E element));

  /// Builds a new list by applying a function to all elements of this list.
  /// This differs from [map] because the transformation function has the
  /// element index.
  IList<T> mapIndexed<T>(T f(int index, E element));

  /// Returns a copy of this list where the [oldValue] is replaced
  /// by the [newValue].
  IList<E> patch(E oldValue, E newValue);

  /// Returns a copy of this list where the [value] is removed.
  IList<E> remove(E value);

  /// Access a [Iterable] to be used in for-loops
  Iterable<E> get iterator;

  /// Returns a read-only dart:core [List].
  List<E> asList();
}

/// Implement an empty [IList].
class EmptyIList<E> implements IList<E> {
  /// Creates an [EmptyIList].
  ///
  /// Note: To create an empty list use [IList.empty] instead.
  const EmptyIList();

  @override
  E operator [](int index) => throw IndexOutOfBoundsException();

  @override
  IList<E> append(E element) => ValueIList([element]);

  @override
  List<E> asList() => List<E>.unmodifiable(const []);

  @override
  bool contains(E element) => false;

  @override
  bool get isEmpty => true;

  @override
  bool get isNotEmpty => false;

  @override
  Iterable<E> get iterator => const [];

  @override
  int get length => 0;

  @override
  IList<T> map<T>(T Function(E element) f) => EmptyIList<T>();

  @override
  IList<T> mapIndexed<T>(T Function(int index, E element) f) => EmptyIList();

  @override
  IList<E> patch(E oldValue, E newValue) => this;

  @override
  IList<E> remove(E value) => this;

  @override
  bool operator ==(Object other) => other is IList<E> && other.isEmpty;

  @override
  int get hashCode => _hashObjects(const []);

  @override
  String toString() => "[]";
}

/// Implement an [IList] with some values.
class ValueIList<E> implements IList<E> {
  final List<E> _dartList;

  /// Creates a new [ValueIList] form a non-empty [Iterable]
  /// of type [E].
  /// If [elements] is null or empty an [AssertionError] will
  /// be throws.
  ///
  /// Note: To create a list with value use [IList.from] instead.
  ValueIList(Iterable<E> elements)
      : assert(elements != null),
        assert(elements.isNotEmpty),
        _dartList = List.of(elements);

  @override
  E operator [](int index) {
    if (index < 0 || index >= length) throw IndexOutOfBoundsException();
    return _dartList[index];
  }

  @override
  IList<E> append(E element) {
    final result = List<E>.of(_dartList, growable: true);
    result.add(element);
    return ValueIList(result);
  }

  @override
  List<E> asList() => List.unmodifiable(_dartList);

  @override
  bool contains(E element) => _dartList.contains(element);

  @override
  bool get isEmpty => _dartList.isEmpty;

  @override
  bool get isNotEmpty => _dartList.isNotEmpty;

  @override
  Iterable<E> get iterator => _dartList;

  @override
  int get length => _dartList.length;

  @override
  IList<T> map<T>(T Function(E element) f) =>
      mapIndexed((_, element) => f(element));

  @override
  IList<T> mapIndexed<T>(T Function(int index, E element) f) {
    final result = List<T>.empty(growable: true);
    for (int i = 0; i < length; i++) {
      result.add(f(i, this[i]));
    }
    return ValueIList(result);
  }

  @override
  IList<E> patch(E oldValue, E newValue) {
    final idx = _dartList.indexOf(oldValue);
    if (idx < 0) return this;
    final result = List<E>.of(_dartList);
    result[idx] = newValue;
    return ValueIList(result);
  }

  @override
  IList<E> remove(E value) {
    final result = List<E>.of(_dartList, growable: true);
    result.remove(value);
    if (result.isEmpty) return IList<E>.empty();
    return ValueIList(result);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ValueIList<E>) return false;
    final ValueIList<E> castedOther = other;
    if (castedOther.length != length) return false;
    if (castedOther.hashCode != hashCode) return false;
    for (var i = 0; i != length; ++i) {
      if (castedOther[i] != this[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => _hashObjects(_dartList);

  @override
  String toString() => _dartList.toString();
}

/// Computes the hash code of a list of objects.
int _hashObjects<T>(Iterable<T> objects) {
  int _combine(int hash, int value) {
    hash = 0x1fffffff & (hash + value);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  int _finish(int hash) {
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }

  return _finish(objects.fold(0, (a, e) => _combine(a, e.hashCode)));
}

/// Class representing an [Exception] thrown when the someone tries to access
/// an element of an [IList] with an index that is outside the bound of the list.
class IndexOutOfBoundsException implements Exception {
  const IndexOutOfBoundsException();
}
