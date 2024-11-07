import 'package:hmi_core/hmi_core_json.dart';
import 'package:hmi_core/hmi_core_result.dart';

///
class FakeJsonMap<T> implements JsonMap<T> {
  final ResultF<Map<String, T>> _decodedResult;
  ///
  const FakeJsonMap(this._decodedResult);
  //
  @override
  Future<ResultF<Map<String, T>>> get decoded => Future.value(_decodedResult);
}