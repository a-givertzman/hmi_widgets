import 'dart:async';
import 'package:hmi_core/hmi_core.dart';

class BufferedStream<T> {
  final _log = Log('${BufferedStream<T>}')..level = LogLevel.debug;
  final StreamController<T> _controller;
  late final StreamSubscription<T> _subscription;
  final T? initalValue;
  T? _lastValue;
  bool _isUpdated = false;
  BufferedStream(
    Stream<T> stream, {
    T? initValue,
  }) :
    _controller = StreamController<T>(),
    _lastValue = initValue,
    initalValue = initValue
  {
    _subscription = stream.listen((event) {
      _log.debug('[.stream.listen] event: $event');
      _lastValue = event;
      if (!_isUpdated) _isUpdated = true;
      _controller.add(event);
    });
    _controller.onCancel =  () {
      _log.debug('[._controller.onCancel] canceleing subscription...');
      _subscription.cancel().then((value) {
        _log.debug('[._controller.onCancel] subscription canceled.');
      });
    };
  }
  ///
  Stream<T> get stream => _controller.stream;
  ///
  T? get value => _lastValue;
  ///
  T? get initialValue => initalValue;
  ///
  bool get isUpdated => _isUpdated;
  ///
  Future<void> dispose() {
    return _subscription.cancel();
  }
}
