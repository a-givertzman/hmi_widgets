import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
class FakeJsonMap<T> implements JsonMap<T> {
  final ResultF<Map<String, T>> _decodedResult;
  ///
  const FakeJsonMap(this._decodedResult);
  //
  @override
  Future<ResultF<Map<String, T>>> get decoded => Future.value(_decodedResult);
}