import 'package:flutter/foundation.dart';
///
typedef IntCallback = void Function(int value);
///
class DropDownControlButtonNotifier {
  final _intListeners = ObserverList<IntCallback>();
  ///
  void addListener(IntCallback callback) {
    _intListeners.add(callback);
  }
  ///
  void removeListeners() {
    _intListeners.clear();
  }
  ///
  void add(int event) {
    for (final listener in _intListeners) {
      listener.call(event);
    }
  }
}
