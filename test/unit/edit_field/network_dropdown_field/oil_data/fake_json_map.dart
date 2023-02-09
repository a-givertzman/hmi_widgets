import 'package:hmi_core/hmi_core.dart';
///
class FakeJsonMap<T> implements JsonMap<T> {
  final Map<String, T> _decoded;
  const FakeJsonMap(this._decoded);
  @override
  Future<Map<String, T>> get decoded => Future.value(_decoded);
}