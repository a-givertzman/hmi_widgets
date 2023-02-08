import 'package:flutter/services.dart';
import 'package:hmi_core/hmi_core.dart';

class SwlData {
  static const _debug = true;
  final TextFile _xCsvFile;
  final TextFile _yCsvFile;
  final List<TextFile> _swlCsvFiles;
  final String _assetPath;
  final int _count;
  ///
  /// xCsvFile load from '$_assetPath/x.csv'
  /// yCsvFile load from '$_assetPath/y.csv'
  SwlData({
    required TextFile xCsvFile,
    required TextFile yCsvFile,
    required List<TextFile> swlCsvFiles,
    required String assetPath,
    required int count,
  }) :
    _xCsvFile = xCsvFile,
    _yCsvFile = yCsvFile,
    _swlCsvFiles = swlCsvFiles,
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
  Future<List<double>> _loadAsset(TextFile textFile) {
    return textFile.content
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
  Future<List<double>> get x => _loadAsset(_xCsvFile);
  ///
  Future<List<double>> get y => _loadAsset(_yCsvFile);
  ///
  Future<List<List<double>>> get swl async {
    return Future.wait(
      List.generate(_count, (i) {
        return _loadAsset('$_assetPath/swl_$i.csv');
      })
    );
  }
}
