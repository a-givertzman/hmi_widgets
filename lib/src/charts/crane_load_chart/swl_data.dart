import 'package:flutter/services.dart';
import 'package:hmi_core/hmi_core.dart';

class SwlData {
  static const _debug = true;
  final String _assetPath;
  final int _count;
  ///
  SwlData({
    required String assetPath,
    required int count,
  }) :
    _assetPath = assetPath,
    _count = count;
  ///
  List<double> _parseStringList(List<String> strings) {
    return strings.map((e) {
      try {
        final v = double.parse(e);
        return v;
      } catch (error) {
        log(_debug, 'Ошибка в методе $runtimeType._parseStringList() значение: $e \nошибка: $error'); 
        return 0.0;       
      }
    }).toList();
  }
  ///
  Future<List<double>> _loadAsset(String assetName) {
    return rootBundle.loadString(assetName)
      .then((value) {
        final doubleList = _parseStringList(
          value.replaceAll('\n', ';').replaceAll(',', '.').trim().split(';'),
        );
        return doubleList;
      })
      .onError((error, stackTrace) {
        throw Failure.unexpected(
          message: 'Ошибка в методе _loadAsset класса $runtimeType:\n$error',
          stackTrace: stackTrace,
        );        
      });
  }
  ///
  Future<List<double>> get x => _loadAsset('$_assetPath/x.csv');
  ///
  Future<List<double>> get y => _loadAsset('$_assetPath/y.csv');
  ///
  Future<List<List<double>>> get swl async {
    return Future.wait(
      List.generate(_count, (i) {
        return _loadAsset('$_assetPath/swl_$i.csv');
      })
    );
  }
}
