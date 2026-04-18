extension SafeCast on Object? {
  T? as<T extends Object?>() {
    final self = this;
    return self is T ? self : null;
  }

  /// Safely cast to a List&lt;T&gt;, returning an empty list if not a List or if elements can't be cast
  ///
  /// Example:
  /// ```dart
  /// final list = '1,2,3'.asListOf<int>();
  /// print(list); // [1, 2, 3]
  /// ```
  List<T> asListOf<T>() {
    final self = this;
    if (self is! List) return [];

    try {
      return self.cast<T>();
    } catch (e) {
      return [];
    }
  }
}
