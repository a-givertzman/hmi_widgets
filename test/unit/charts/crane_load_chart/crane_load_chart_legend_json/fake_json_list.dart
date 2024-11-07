import 'package:hmi_core/hmi_core_json.dart';
import 'package:hmi_core/hmi_core_result.dart';

///
class FakeJsonList<T> implements JsonList<T> {
  final ResultF<List<T>> _decodedResult;
  const FakeJsonList(this._decodedResult);
  @override
  Future<ResultF<List<T>>> get decoded => Future.value(_decodedResult);
}