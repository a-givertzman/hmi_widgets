import 'package:hmi_core/hmi_core.dart';
///
class SwlData {
  static final _log = const Log('SwlData')..level = LogLevel.info;
  final TextFile _xCsvFile;
  final TextFile _yCsvFile;
  final List<TextFile> _swlCsvFiles;
  ///
  /// [xCsvFile] load from '$_assetPath/x.csv'
  /// [yCsvFile] load from '$_assetPath/y.csv'
  /// [swlCsvFiles] load from '$_assetPath/swl_$i.csv'
  SwlData({
    required TextFile xCsvFile,
    required TextFile yCsvFile,
    required List<TextFile> swlCsvFiles,
  }) :
    _xCsvFile = xCsvFile,
    _yCsvFile = yCsvFile,
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
  Future<List<List<double>>> get swl {
    return Future.wait(
      _swlCsvFiles.map((swlFile) => _loadAsset(swlFile)),
    );
  }
}
