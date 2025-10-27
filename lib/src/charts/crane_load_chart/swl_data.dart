import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_core/hmi_core_text_file.dart';

///
class SwlData {
  static final _log = const Log('SwlData')..level = LogLevel.debug;
  final List<TextFile> _xCsvFiles;
  final List<TextFile> _yCsvFiles;
  final List<TextFile> _swlCsvFiles;
  ///
  /// [xCsvFile] load from '$_assetPath/x.csv'
  /// [yCsvFile] load from '$_assetPath/y.csv'
  /// [swlCsvFiles] load from '$_assetPath/swl_$i.csv'
  SwlData({
    required List<TextFile> xCsvFiles,
    required List<TextFile> yCsvFiles,
    required List<TextFile> swlCsvFiles,
  }) :
    _xCsvFiles = xCsvFiles,
    _yCsvFiles = yCsvFiles,
    _swlCsvFiles = swlCsvFiles;
  ///
  List<double> _parseStringList(List<String> strings) {
    return strings
      .where((string) => string.trim().isNotEmpty)
      .map((e) {
        try {
          final v = double.parse(e);
          return v;
        } catch (error) {
          _log.error('Ошибка в методе $runtimeType._parseStringList() значение: $e \nошибка: $error'); 
          return 0.0;       
        }
      }).toList();
  }
  ///
  Future<List<double>> _loadAsset(TextFile textFile) {
    return textFile.content
      .then((result) {
        return switch(result) {
          Ok(:final value) => value,
          Err(:final error) => throw error,
        };
      })
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
  Future<List<List<double>>> get x {
    return Future.wait(
      _xCsvFiles.map((xFile) => _loadAsset(xFile)),
    );
  }
  ///
  Future<List<List<double>>> get y {
    return Future.wait(
      _yCsvFiles.map((yFile) => _loadAsset(yFile)),
    );
  }
  ///
  Future<List<List<double>>> get swl {
    return Future.wait(
      _swlCsvFiles.map((swlFile) => _loadAsset(swlFile)),
    );
  }
}
