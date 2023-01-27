/// Computes its [value] lazily, on first appeal.
class LazyLoadable<T> {
  T? _value;
  final Future<T> Function() _load;
  ///
  LazyLoadable({
    required Future<T> Function() load,
  }) : _load = load;
  ///
  /// Returns value if it is already loaded,
  /// otherwise loads it first, then returns.
  Future<T> get value {
    if (_value != null) {
      return Future.value(_value);
    }
    return _load()
      .then((value) {
        _value = value;
        return value;
      });
  }
}