import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
/// Reads oil names and spec data for [SettingsPage] - HPU 
/// from assets json file
class OilData {
  static final _log = const Log('OilData')..level = LogLevel.debug;
  final JsonMap<Map<String, dynamic>> _jsonMap;
  final Map<String, Map<String, dynamic>> _data =  {};
  ///
  OilData({
    required JsonMap<Map<String, dynamic>> jsonMap,
  }) :
    _jsonMap = jsonMap;
  ///
  /// List of names of awailable oil types
  Future<List<String>> names() async {
    if (_data.isEmpty) {
      await _jsonMap.decoded
      .then((result) {
        return switch(result) {
          Ok(:final value) => value,
          Err(:final error) => throw error,
        };
      })
      .then((value) => _data.addAll(value))
      .onError((error, stackTrace) {
        throw Failure.unexpected(
          message: 'Ошибка в методе names класса $runtimeType:\n$error',
          stackTrace: stackTrace,
        );        
      });
    }
    final namesList = _data.keys.toList();
    _log.debug('[$OilData.names] namesList: $namesList');
    return Future.value(namesList);
  }
}