import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hmi_core/hmi_core.dart';

///
/// Reads oil names and spec data for [SettingsPage] - HPU 
/// from assets json file
class OilData {
  static const _debug = true;
  final String _assetName;
  final Map<String, Map<String, dynamic>> _data =  {};
  ///
  OilData({
    required String assetName,
  }) :
    _assetName = assetName;
  ///
  /// List of names of awailable oil types
  Future<List<String>> names() async {
    if (_data.isEmpty) {
      await _loadAsset('$_assetName')
      .then((value) => _data.addAll(value));
    }
    final namesList = _data.keys.toList();
    log(_debug, '[$OilData.names] namesList: ', namesList);
    return Future.value(namesList);
  }
  ///
  Future<Map<String, Map<String, dynamic>>> _loadAsset(String assetName) {
    return rootBundle.loadString(assetName)
      .then((value) {
        final jsonResult = json.decode(value) as Map<String, dynamic>;
        return jsonResult.map((key, value) {
          return MapEntry(
            key, 
            value as Map<String, dynamic>,
          );
        });
      })
      .onError((error, stackTrace) {
        throw Failure.unexpected(
          message: 'Ошибка в методе _loadAsset класса $runtimeType:\n$error',
          stackTrace: stackTrace,
        );        
      });
  }  
}