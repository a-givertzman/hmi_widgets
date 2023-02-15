import 'package:hmi_core/hmi_core.dart';
///
class FakeJsonList<T> implements JsonList<T> {
  final List<T> _list;
  const FakeJsonList(this._list);
  @override
  Future<List<T>> get decoded => Future.value(_list);
}